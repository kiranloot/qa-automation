require_relative 'subscription_object'

class LevelUpSubscription < Subscription
  attr_accessor :name, :months, :product, :shirt_size, :waist_size, :recurly_name

  def initialize(months, product=nil)
    super
  end

  def set_name
    case product
    when 'accessory'
      @recurly_name = "LC - LU - Accessory - #{@months} month"
      @name = "Level Up Accessories #{@months} Month"
    when 'level-up-bundle-tshirt-accessories'
      @recurly_name = "LC - LU - Bundle (socks + wearables) - #{@months} month"
      @name = "Level Up T-Shirt + Accessories Bundle #{@months} Month"
    when 'socks'
      @recurly_name = "LC - LU - Socks - #{@months} month"
      @name = "Level Up Socks #{@months} Month"
    when 'level-up-tshirt'
      @recurly_name = "LC - LU - T-Shirt - #{@months} month"
      @name = "Level Up T-Shirt #{@months} Month"
    when 'wearable'
      @recurly_name = "LC - LU - Wearable - #{@months} month"
      @name = "Level Up Wearable #{@months} Month"
    when 'level-up-bundle-socks-wearable'
      @recurly_name = "LC - LU - Bundle (socks + wearables) - #{@months} month"
      @name = "Level Up Bundle (socks & wearable) #{@months} Month"
    end
  end

  def recurly_subscription_name
    # Use subscription data to assemble the subscription name as it's
    # displayed on recurly
  end
end
