class Coupon < ActiveRecord::Base
  STATUSES = %w(Active Inactive)
  validates :code, uniqueness: true, presence: true

  belongs_to :promotion, inverse_of: :coupons
  delegate :adjustment_type, :adjustment_amount,  to: :promotion
  has_many :promo_conversions
  delegate :adjustment_type,   to: :promotion
  delegate :adjustment_amount, to: :promotion
  delegate :one_time_use, to: :promotion

  before_validation :downcase_code, if: Proc.new { code_changed? && code.present? }

  def archive!
    update_attributes(status: 'Inactive', archived_at: DateTime.now)
  end

  def total_discount_amount(cost)
    if adjustment_type == 'Fixed'
      adjustment_amount
    else # adjustment_type == 'Percentage'
      cost * (adjustment_amount * 0.01)
    end
  end

  private

  def downcase_code
    self.code.downcase!
  end
end
