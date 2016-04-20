require_relative 'subscription_object'

class LevelUpSubscription < Subscription
  attr_accessor :name, :months, :product, :shirt_size, :waist_size, :recurly_name

  def initialize(months, product=nil)
    super
  end

  def set_name
    case product
    when /(accessory|for her)/
      @recurly_name = "LC - LU - Accessory - #{@months} month"
      @name = "Loot for Her #{@months} Month Subscription"
    when /(level-up-bundle-tshirt-accessories|for her \+ tee)/
      @recurly_name = "LC - LU - Bundle (tshirt + accessories) - #{@months} month"
      @name = "Loot for Her + Loot Tees #{@months} Month Subscription"
    when 'socks'
      @recurly_name = "LC - LU - Socks - #{@months} month"
      @name = "Loot Socks #{@months} Month"
    when /(level-up-tshirt|tees)/
      @recurly_name = "LC - LU - T-Shirt - #{@months} month"
      @name = "Loot Tees #{@months} Month"
    when /wearables?/
      @recurly_name = "LC - LU - Wearable - #{@months} month"
      @name = "Loot Wearables #{@months} Month"
    when /(level-up-bundle-socks-wearable|socks + wearable)/
      @recurly_name = "LC - LU - Bundle (socks + wearables) - #{@months} month"
      @name = "Loot Socks + Loot Wearables #{@months} Month"
    end
  end

  def recurly_subscription_name
    # Use subscription data to assemble the subscription name as it's
    # displayed on recurly
  end
end
