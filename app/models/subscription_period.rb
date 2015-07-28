class SubscriptionPeriod < ActiveRecord::Base
  belongs_to :subscription
  has_many :subscription_units

  scope :active,  -> { where(status: 'active') }
  scope :current, -> { where(status: ['active', 'past_due'])}

  # Callbacks
  before_create :does_not_have_active_period?

  def units_remaining
    [term_length - subscription_units.shipped_or_awaiting_shipment.size, 0].max
  end

  def current_unit
    subscription_units.where(month_year: Subscription::CrateDateCalculator.current_crate_month_year).first
  end

  private
    def does_not_have_active_period?
      !subscription.current_period.present?
    end
end
