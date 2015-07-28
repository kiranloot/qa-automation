class Promotion < ActiveRecord::Base
  TRIGGER_EVENTS = %w( SIGNUP REACTIVATION UPGRADE )
  ADJUSTMENT_TYPES = %w( Fixed Percentage )

  validates_presence_of :adjustment_amount, :name, :starts_at, :ends_at
  validates :coupon_prefix, presence: true, uniqueness: { case_sensitive: false }, coupon_prefix_format: true, length: { maximum: 50 }
  validates_exclusion_of :one_time_use, in: [nil]
  validates_inclusion_of :adjustment_type, in: ADJUSTMENT_TYPES
  validates_numericality_of :conversion_limit, allow_nil: true, only_integer: true, greater_than_or_equal_to: 0, if: :one_time_use

  has_and_belongs_to_many :eligible_plans, class_name: 'Plan'
  has_many :coupons, dependent: :destroy, inverse_of: :promotion
  accepts_nested_attributes_for :coupons
  has_many :promo_conversions

  after_initialize :set_defaults, unless: :persisted?

  def generate_new_coupons(codes)
    new_coupons = build_coupons(codes)

    Promotion.transaction do
      coupons.create(new_coupons)
    end
  end

  def create_new_eligible_plans(eligible_plan_ids)
    self.eligible_plans |= Plan.find(eligible_plan_ids)
    save!
  end

  def total_conversions
    coupons.where.not(usage_count: nil).pluck(:usage_count).sum
  end

  def days_active
    return 0 if starts_at.nil?

    start_time = starts_at.to_time
    end_time   = Time.now > ends_at.to_time ? ends_at.to_time : Time.now

    TimeDifference.between(start_time, end_time).in_days.round
  end

  def total_revenue
    promo_conversions.pluck(:product_discounted_cost).sum
  end

  def total_savings
    promo_conversions.pluck(:product_initial_cost).sum - total_revenue
  end

  # TODO: Remove this when no longer using Chargify.
  def main_coupon_code
    coupons.order(:created_at).pluck(:code).first
  end

  private

    def build_coupons(codes)
      new_coupons = []

      codes = codes.split(/\r?\n/).map(&:downcase)

      codes.each do |code|
        new_coupons << { code: code, usage_count: 0 }
      end

      new_coupons
    end

    def set_defaults
      self.one_time_use ||= false
    end
end
