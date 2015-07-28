require 'activemodel_errors_standard_methods'

class Subscription::CreationHandler
  include ActiveModelErrorsStandardMethods
  include SubscriptionCreationServiceInjector

  attr_reader :checkout, :user

  def initialize(args = {})
    @checkout = args[:checkout]
    @user     = args[:user]
  end

  def fulfill
    create_gateway_subscription

    unless errors.any?
      handle_successful_creation
    end
  end

  def create_gateway_subscription
    gateway.create_subscription

    if gateway_errors = gateway.errors.presence
      gateway_errors.each do |k, gateway_error|
        errors.add(k, gateway_error)
      end
    end
  end

  def handle_successful_creation
    begin
      create_database_subscription
      create_subscription_period
      store_user_account
      save_checkout
      handle_promotion_usage

      readjust_rebill_date
      send_receipts
    rescue => e
      Airbrake.notify(
        error_class:       'Subscription Successful Creation Error',
        error_message:     "Reason: #{e}",
        backtrace:         $ERROR_POSITION,
        environment_name:  ENV['RAILS_ENV']
      )
    end
  end

  def store_user_account
    user.recurly_accounts.create!(
      recurly_account_id: gateway.account_id
    )
  end

  # TODO: Rename this.
  def send_receipts
    SubscriptionWorkers::WelcomeEmail.perform_async(database_subscription.user_id, database_subscription.id)
    SubscriptionWorkers::EmailListUpdater.perform_async(user.id)
  end

  def create_database_subscription
    @database_subscription = Subscription.create!(
      shirt_size: checkout.shirt_size,
      name: checkout_name,
      billing_address: build_billing_address,
      shipping_address: build_shipping_address,
      user_id: user.id,
      plan_id: checkout.plan.id,
      coupon_code: checkout.coupon.code,
      last_4: credit_card_last_four,
      next_assessment_at: next_assessment_at,
      recurly_account_id: gateway.account_id,
      recurly_subscription_id: gateway.subscription_id
    )
  end

  def save_checkout
    checkout.recurly_subscription_id = gateway.subscription_id
    checkout.subscription_id          = database_subscription.id
    checkout.save!
  end

  def create_subscription_period
    SubscriptionPeriod::Handler.new(database_subscription).handle_subscription_created
  end

  # TODO: Return null_subscription instead of nil.
  def database_subscription
    @database_subscription ||= nil
  end

  private
    def checkout_name
      "Subscription #{user.subscriptions.count + 1}"
    end

    def credit_card_last_four
      checkout.credit_card_number.split('-').last[-4..-1]
    end

    def next_assessment_at
      checkout.next_assessment_at
    end

    def build_billing_address
      BillingAddress.new(
        full_name: checkout.billing_address_full_name,
        line_1: checkout.billing_address_line_1,
        line_2: checkout.billing_address_line_2,
        city: checkout.billing_address_city,
        state: checkout.billing_address_state,
        zip: checkout.billing_address_zip,
        country: checkout.billing_address_country
      )
    end

    def build_shipping_address
      ShippingAddress.new(
        first_name: checkout.shipping_address_first_name,
        last_name: checkout.shipping_address_last_name,
        line_1: checkout.shipping_address_line_1,
        line_2: checkout.shipping_address_line_2,
        city: checkout.shipping_address_city,
        state: checkout.shipping_address_state,
        zip: checkout.shipping_address_zip,
        country: checkout.shipping_address_country
      )
    end

    def handle_promotion_usage
      PromotionHandler.new(
        coupon: checkout.coupon,
        product: database_subscription,
        product_total: checkout.total,
        product_subtotal: checkout.subtotal,
        tax_rate: checkout.tax_rate
      ).fulfill
    end

    def readjust_rebill_date
      database_subscription.readjust_rebilling_date(checkout.next_assessment_at) if LootcrateConfig.within_rebill_adjustment_rule?
    end

    def gateway
      @gateway ||= subscription_creation_service.new(checkout, user)
    end
end
