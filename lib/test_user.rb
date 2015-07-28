require 'faker'

class TestUser
  attr_accessor :user, :coupon_code

  def initialize options = {}
    @plan_name               = options[:plan_name]
    @coupon_code             = options[:coupon_code] || ''
    @user                    = options[:user]
  end

  def start
    create_user
    create_recurly_subscription
    create_lootcrate_subscription
  end

  def create_existing_subscription
    create_user
    create_recurly_subscription(trial_ends_at: DateTime.now + 10.days)
    created_at = ([plan.period - 2, 0].max).months.ago
    create_lootcrate_subscription(created_at: created_at)
    create_subscription_unit
  end

  def create_user
    @user ||= User.create(
      email: ::Faker::Internet.user_name + rand(1000) + '@mailinator.com',
      password: 'password'
    )
  end

  def plan
    @plan ||= Plan.find_by_name(@plan_name) || Plan.find_by_name('1-month-subscription')
  end

  def create_lootcrate_subscription(options = {})
    @lootcrate_sub = Subscription.create(
        {
          shirt_size: 'M M',
          user_id: user.id,
          plan_id: plan.id,
          last_4: credit_card_last_four,
          next_assessment_at: @recurly_subscription.current_period_ends_at,
          recurly_subscription_id: @recurly_subscription.uuid,
          recurly_account_id: @recurly_subscription.account.account_code,
          shipping_address_attributes: {
            first_name: recurly_account.first_name,
            last_name: recurly_account.last_name,
            line_1: shipping_address.address1,
            line_2: shipping_address.address2,
            country: shipping_address.country,
            city: shipping_address.city,
            state: shipping_address.state,
            zip: shipping_address.zip
          },
          billing_address_attributes: {
            full_name: "#{billing_info[:first_name]} #{billing_info[:last_name]}",
            line_1: billing_info[:address1],
            line_2: billing_info[:address2],
            country: billing_info[:country],
            city: billing_info[:city],
            state: billing_info[:state],
            zip: billing_info[:zip]
          }
        }.merge(options)
      )

    SubscriptionPeriod::Handler.new(@lootcrate_sub).handle_subscription_created
    handle_promotion_usage unless coupon.nil?
  end

  def create_recurly_subscription(options = {})
    sub = Recurly::Subscription.new({
      plan_code: plan.name,
      account: recurly_account,
      coupon_code: coupon_code,
      currency: 'USD'
    }.merge(options))

    sub.save

    @recurly_subscription = sub
  end

  def recurly_account
    @recurly_account ||= Recurly::Account.new({
      account_code: Faker::Code.ean,
      email: @user.email,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      billing_info: billing_info,
      address: shipping_address
    })
  end

  def billing_info
    @billing_info ||= {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      address1: address[:address1],
      city: address[:city],
      state: address[:state],
      country: address[:country],
      zip: address[:zip],
      number: '4111-1111-1111-1111',
      month: 10,
      year: 2019,
      verification_value: '123'
    }
  end

  def shipping_address
    @shipping_address ||= Recurly::Address.new({
      address1: address[:address1],
      city: address[:city],
      state: address[:state],
      country: address[:country],
      zip: address[:zip]
    })
  end

  def address
    {
      address1: "3433 Pasadena Ave",
      city: "Los Angeles",
      state: "CA",
      zip: 90031,
      country: "US"
    }
  end

  def create_customer_account
    user.recurly_accounts.create(
      recurly_account_id: @recurly_subscription.account.account_code
    )
  end

  def cancel_subscription
    @recurly_subscription.terminate
    @lootcrate_sub.update_attributes(subscription_status: 'canceled')
  end

  def create_subscription_unit
    SubscriptionUnit.skip_callback(:save, :before, :ensure_not_already_shipped)

    created_at   = @lootcrate_sub.created_at
    current_time = DateTime.now

    while created_at < current_time
      month_year = created_at.strftime('%^b%Y')

      sub_unit = SubscriptionUnit.new(
        subscription_period_id: @lootcrate_sub.current_period.id,
        tracking_number: 'ABC123',
        month_year: month_year,
        shirt_size: 'M M',
        shipping_address: @lootcrate_sub.shipping_address,
        service_code: 'usps_first_class_mail',
        status: 'shipped'
      )

      sub_unit.save(validate: false)

      created_at += 1.month
    end

    SubscriptionUnit.set_callback(:save, :before, :ensure_not_already_shipped)
  end

  def create_store_credit
    StoreCredit.create(
      amount: 5,
      reason: 'Test',
      status: 'redeemed',
      friendbuy_conversion_id: ::Faker::Number.number(6),
      referrer_user_id: user.id,
      referrer_user_email: user.email,
      referred_user_id: random_referred_user.id,
      referred_user_email: random_referred_user.email
    )
  end

  def coupon
    Coupon.find_by_code @coupon_code
  end

  def handle_promotion_usage
    PromotionHandler.new(
      coupon: coupon,
      product: @lootcrate_sub,
      product_total: total_cost,
      product_subtotal: plan.cost,
      tax_rate: 0.09
    ).fulfill
  end

  private
  def total_cost
    [plan.cost - coupon_discount_amount + tax_charge_amount, 0].max
  end

  def coupon_discount_amount
    amount = coupon.try(:total_discount_amount, plan.cost)

    amount.nil? ? 0 : amount
  end

  def tax_charge_amount
    [plan.cost - coupon_discount_amount, 0].max * 0.09
  end

  def random_referred_user
    @random_referred_user ||= User.where('id != ?', user.id).first
  end

  def credit_card_last_four
    '1111'
  end
end
