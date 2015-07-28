class Checkout < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  COMMON_ATTRIBUTES = %i(
    shirt_size
    first_name
    last_name
    shipping_address_first_name
    shipping_address_last_name
    shipping_address_line_1
    shipping_address_line_2
    shipping_address_city
    shipping_address_state
    shipping_address_zip
    shipping_address_country
    billing_address_full_name
    billing_address_line_1
    billing_address_line_2
    billing_address_city
    billing_address_state
    billing_address_zip
    billing_address_country
    credit_card_number
    credit_card_expiration_date
    credit_card_cvv
  )

  belongs_to :user
  belongs_to :plan

  # CLEANUP remove chargify_coupon_code from table, not in use right now
  attr_accessor :quantity, :total, :coupon, :tax, :coupon_in_dollars,
    *COMMON_ATTRIBUTES

  #delegate :country, to: :plan, prefix: true # executes twice the amount of
  #queries
  delegate :name, to: :plan, prefix: true

  validate :full_name_format
  validates_presence_of \
    :shirt_size,
    :shipping_address_first_name,
    :shipping_address_last_name,
    :shipping_address_line_1,
    :shipping_address_city,
    :shipping_address_state,
    :shipping_address_zip,
    :shipping_address_country,
    :billing_address_full_name,
    :billing_address_line_1,
    :billing_address_city,
    :billing_address_state,
    :billing_address_zip,
    :billing_address_country,
    :credit_card_number,
    :credit_card_expiration_date,
    :credit_card_cvv,
    :user,
    :plan

  def full_name_format
    return if billing_address_full_name.blank? # this is handled by validates presence of
    if billing_address_full_name.strip.split(' ', 2).count < 2
      errors.add(:billing_address_full_name, "Must contain first and last name.")
    end
  end

  def fulfill
    return unless self.valid?

    creation_handler.fulfill

    if creation_errors = creation_handler.errors.presence
      creation_errors.each do |k, creation_error|
        errors.add(k, creation_error)
      end
    end
  end

  # Currently just our plan cost
  def subtotal
    order_calculator.subtotal
  end

  def plan_renewal_cost
    order_calculator.plan_renewal_cost
  end

  def total
    order_calculator.total
  end

  def coupon_discount_amount
    order_calculator.coupon_discount_amount
  end

  def coupon
    @coupon ||= validate_coupon(coupon_code)
  end

  def tax_charges_after_discount
    order_calculator.tax_charge_amount
  end

  def tax_rate
    order_calculator.tax_rate
  end

  def tax_region
    order_calculator.tax_region
  end

  def next_assessment_at
    order_calculator.next_assessment_at
  end

  # TODO: It should be the responsibility of the validator to return a coupon or null_coupon object.
  def validate_coupon(coupon_code)
    return NullCoupon.new unless coupon_code.present? && plan

    coupon_validator = CouponValidator.new(coupon_code, plan, 'SIGNUP')
    coupon_validator.validate!

    if coupon_validator.valid?
      return coupon_validator.coupon
    else
      NullCoupon.new
    end
  end

  def created_subscription
    creation_handler.database_subscription
  end

  def billing_address_first_name
    billing_address_name.first_name
  end
  
  def billing_address_last_name
    billing_address_name.last_name
  end

  private
    def order_calculator
      @order_calculator ||= OrderCalculator.new(
        products: [plan],
        shipping_address_zip: shipping_address_zip,
        coupon: coupon
      )
    end

    def creation_handler
      @creation_handler ||= Subscription::CreationHandler.new(
        checkout: self,
        user: user
      )
    end

    def billing_address_name
      @billing_address_name ||= FullNameSplitter::Splitter.new(billing_address_full_name)
    end
end
