# == Schema Information
#
#  id                   :integer      not null, primary key
#  user_id              :integer
#  chargify_customer_id :integer
#  created_at           :datetime     not null
#  updated_at           :datetime     not null
#

class ChargifyCustomer < ActiveRecord::Base
  # has_many :subscriptions, foreign_key: :customer_id
  belongs_to :user

  validates_uniqueness_of :chargify_customer_id

  def destroy_if_homeless
    destroy if Subscription.where(customer_id: chargify_customer_id).count == 0
  end
end
