class PromoConversion < ActiveRecord::Base
  belongs_to :promotion
  belongs_to :coupon
end
