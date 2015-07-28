class SubscriptionSkippedMonth < ActiveRecord::Base
  belongs_to :subscription
  validates_presence_of :subscription_id, :month_year
  validates_uniqueness_of :month_year, scope: :subscription_id
end
