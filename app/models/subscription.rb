class Subscription < ActiveRecord::Base
  include PostponementServiceInjector
  include LootcrateCoreDates

  belongs_to :user, inverse_of: :subscriptions
  belongs_to :plan
  belongs_to :billing_address
  belongs_to :shipping_address
  # belongs_to :chargify_customer, class_name: 'ChargifyCustomer', foreign_key: 'chargify_customer_id'
  has_paper_trail

  has_many :subscription_periods
  has_many :subscription_skipped_months

  validates_presence_of :shirt_size
  validates_presence_of :user, :subscription_status
  validates_associated  :billing_address
  validates_associated  :shipping_address
  # validates :coupon_code, :coupon_code => true, :unless => Proc.new { |a| a.coupon_code.blank? }
  # validates :coupon_code, :coupon_code => true, :allow_blank => true
  # validates :subscription_status, inclusion: { in: ["active", "canceled"] }

  accepts_nested_attributes_for :shipping_address, allow_destroy: :true
  accepts_nested_attributes_for :billing_address, allow_destroy: :true
  accepts_nested_attributes_for :plan, reject_if: proc { |attrs| attrs.all? { |k, v| v.blank? } }

  scope :active, -> { where(subscription_status: 'active') }
  scope :domestic, -> { joins(:shipping_address).where("addresses.country = 'US'") }
  scope :international, -> { joins(:shipping_address).where("addresses.country != 'US'") }

  delegate :name, to: :plan, prefix: true
  delegate :title, to: :plan, prefix: true
  delegate :monthly_cost, to: :plan, prefix: true
  delegate :cost, to: :plan, prefix: true
  delegate :email, to: :user, prefix: true
  delegate :country, to: :plan, prefix: true
  delegate :period, to: :plan, prefix: true
  delegate :full_name, to: :user, prefix: true
  delegate :is_upgradable?, to: :plan

  after_update :propagate_changes_to_unshipped_units

  def remap_chargify!(params)
    # load Chargify::Customer and Chargify::Subscription
    ChargifySwapper.set_chargify_site_for(self)

    remote_customer = Local::Chargify::Customer.find_by_id(customer_id)
    remote_subscription = Local::Chargify::Subscription.find_by_id(chargify_subscription_id)

    # get ChargifyCustomer
    local_customer = ChargifyCustomer.find_by_chargify_customer_id_and_braintree(customer_id, self.braintree)

    # create new Chargify::Subscription and Chargify::Customer
    ba = params[:billing_address]
    cc = ba[:credit_card]
    attrs = {
      plan: plan.name,
      subscription: {
        shipping_address_attributes: shipping_address.attributes.symbolize_keys,
        billing_address_attributes: {
          line_1:  ba[:line_1],
          line_2:  ba[:line_1],
          city:    ba[:city],
          state:   ba[:state],
          zip:     ba[:zip],
          country: ba[:country]
        },
        credit_card: {
          number:     cc[:number],
          expiration: cc[:expiration],
          cvv:        cc[:cvv]
        },
        coupon_code: coupon_code,
        next_billing_at: remote_subscription.next_assessment_at
      }
    }

    ChargifySwapper.set_chargify_site_to_braintree
    new_remote_sub = Local::Chargify::Subscription.new(attrs, user).create

    # map new Chargify::Subscription/Customer ids to local_sub
    self.chargify_subscription_id = new_remote_sub.id
    self.customer_id = new_remote_sub.customer.id
    self.save

    # destroy old local ChargifyCustomer and make new one
    local_customer.destroy_if_homeless
    new_local_customer = ChargifyCustomer.create!(braintree: true, chargify_customer_id: new_remote_sub.customer.id)
    self.user.chargify_customer_accounts << new_local_customer
    self.user.save

    # cancel old chargify subscription
    # load Chargify::Customer and Chargify::Subscription
    ChargifySwapper.set_chargify_site_for(remote_subscription)
    remote_subscription.cancel
  end

  def month_skipped
    subscription_skipped_months.where(
      month_year: [current_crate_month_year, next_crate_month_year]
    ).pluck(:month_year).first
  end

  def has_corrupt_mapping?
    hash = Subscription.where(user_id: user.id, subscription_status: 'active').select('customer_id').group('customer_id').having('count(customer_id) > 1').count

    if hash[customer_id]
      return true
    else
      return false
    end
  end

  def to_s
    "#{looter_name} - #{plan.readable_name}"
  end

  def credit_card
    @credit_card
  end

  def credit_card=(options)
    @credit_card ||= CreditCard.new(options)
  end

  def coupon_in_dollars(current_payment)
    coupon = Coupon.find_by_code(coupon_code)
    if coupon.try(:valid?)
      if coupon.amount_in_cents
        coupon.amount_in_cents/100.0
      elsif coupon.percentage
        current_payment/coupon.percentage
      end
    else
      0
    end
  end

  def readable_shirt_size
    index = GlobalConstants::SHIRT_SIZES.index(self.shirt_size)
    unless index.nil?
      GlobalConstants::READABLE_SHIRT_SIZES[index]
    end
  end

  def self.sync_or_create_from_chargify(chargify_customer_account)
    begin
      user = chargify_customer_account.user
      chargify_customer_id = chargify_customer_account.chargify_customer_id

      ChargifySwapper.set_chargify_site_for(chargify_customer_account)
      customer = Local::Chargify::Customer.find_by_id(chargify_customer_id)

      # Rails.logger.info "subscription count: #{customer.subscriptions.count}".red
      customer.subscriptions.each do |subscription|
        # Rails.logger.info "process subscription"
        match = self.find_by_chargify_subscription_id(subscription.id)

        # Billing Address
        ba_hash = BillingAddress.sync_or_create_billing_address_from_chargify(subscription.credit_card.attributes)

        # Shipping Address
        if match.try(:shipping_address).present?
          sa_hash = {}
        else
          sa_hash = ShippingAddress.sync_or_create_shipping_address_from_chargify(customer.attributes)
        end

        # IMPORTANT - fucked up columns made email and looter_name have each
        # others values so think about that when reading logic in the following.
        survey = LooterInfoSurvey.where(looter_name: user.email, used: false).first

        if match.present?
          if match.looter_name == 'Official Member'
            if survey.present? && (survey.used == false)
              looter_name = survey.email # was looter_name but
              shirt_size  = survey.shirt_size
              survey.used = true
              survey.save
            end
          else
            if survey.present? && (survey.used == false)
              survey.used = true
              survey.save
            end
            looter_name = match.looter_name
            shirt_size  = match.shirt_size
          end
        elsif survey.present? && (survey.used == false)
          looter_name = survey.email
          shirt_size  = survey.shirt_size
          survey.used = true
          survey.save
        end

        # create subscription with chargify_subscription_id and customer_id
        attrs = {
          created_at: subscription.created_at,
          chargify_subscription_id: subscription.id,
          customer_id: chargify_customer_id,
          cost: (subscription.product.price_in_cents / 100.0),
          subscription_status: subscription.state,
          looter_name: looter_name || user.full_name || 'Official Member',
          shirt_size: shirt_size || 'M L'
        }.merge(ba_hash).merge(sa_hash)

        if match.present?
          match.update_attributes(attrs)
          if match.plan.nil?
            plan = subscription.product.handle.scan(/(.*[0-9]-month-subscription|canadian-one-month)/).first.first
            match.plan = Plan.find_by_name(plan)
          end
          if not match.save
            puts "SAVE ERROR - Counldn't save subscription: #{match.errors.full_messages}"
          end
        else
          sub = user.subscriptions.build(attrs)
          plan = subscription.product.handle.scan(/(.*[0-9]-month-subscription|canadian-one-month)/).first.first
          sub.plan = Plan.find_by_name(plan)
          if not sub.save
            puts "SAVE ERROR - Counldn't save subscription: #{sub.errors.full_messages}"
          end
        end
      end
    rescue => e
      logger.error e.inspect
    end
  end

  def get_chargify_subscription
    Local::Chargify::Subscription.find_by_id chargify_subscription_id
  end

  def is_active?
    subscription_status == 'active'
  end

  def next_billing_date
    next_assessment_at.try(:strftime, ('%B %d, %Y'))
  end

  def current_status
    if is_active? && cancel_at_end_of_period
      'CANCELED EOP' # Cancel at end of period
    else
      subscription_status
    end
  end

  def masked_card_number
    "XXXX-XXXX-XXXX-#{last_4}"
  end

  def readjust_rebilling_date(new_billing_date)
    postponement_service_klass.new(self).readjust_rebilling_date(new_billing_date)
  end

  def handle_shipping_address_changed
    propagate_changes_to_unshipped_units
  end

  def period_months
    # TODO: demeter fix
    plan.period.months
  end

  def adjusted_creation_date
    # either return the last moment of the 19th or the first moment of the 20th
    d = creation_date

    nineteenth_of_creation_month = DateTime.new(d.year, d.month, 19).end_of_day.change(offset: '-0500')

    if creation_date < nineteenth_of_creation_month
      d = nineteenth_of_creation_month
    else
      d = nineteenth_of_creation_month + 1.second
    end

    d
  end

  def current_period
    subscription_periods.current.first
  end

  def latest_period
    subscription_periods.last
  end

  def current_unit
    current_period.current_unit
  end

  def redeem_store_credits
    user.store_credits.not_redeemed.each do |store_credit|
      store_credit.redeem(self)
    end
  end

  def address_flagged?
    !!shipping_address.flagged_invalid_at
  end

  private
    def propagate_changes_to_unshipped_units
      periods = subscription_periods.includes(:subscription_units)
                                    .where.not(subscription_units: { status: 'shipped' })

      periods.each do |p|
        p.subscription_units.map(&:handle_subscription_updated)
      end
    end
end
