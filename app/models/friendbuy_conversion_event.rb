class FriendbuyConversionEvent < ActiveRecord::Base
  belongs_to :referrer_user, class_name: 'User', foreign_key: 'share_customer_id'
  # belongs_to :referrer_user, class_name: "User", foreign_key: 'email'
  validates :conversion_id, uniqueness: true

end
