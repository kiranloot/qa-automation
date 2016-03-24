class Subscription
  attr_accessor :name, :months, :product, :shirt_size, :waist_size, :recurly_name

  def initialize(months, product=nil)
    @@plans = {
      'one' => '1',
      'two' => '2',
      'three' => '3',
      'six' => '6',
      'twelve' => '12'
    }
    @months = @@plans[months]
    @shirt_size = 'Mens - S'
    @waist_size = 'Womens - S'
    @product = product
    set_name
  end

  def set_name
    case @product
    when 'Pets'
      @name = "Pets #{@months} Month Subscription"
    when 'Anime'
      @name = "Anime #{@months} Month Subscription"
    when 'Firefly'
      @name = "#{@months} Month Plan Subscription"
    when 'Gaming'
      @name = "Gaming #{@months} Month Subscription"
    when 'Lcdx'
      @name = "Lcdx #{@months} Month Subscription"
    else
      @name = "#{@months} Month Plan Subscription"
    end

    if @product == "Loot Crate"
      @recurly_name = "#{@months} Month Subscription"
    else
      @recurly_name = @name
    end
  end

  def upgrade_string
    if @product == 'Loot Crate'
      return @recurly_name
    else
      return @name
    end
  end



  def recurly_subscription_name
    # Use subscription data to assemble the subscription name as it's
    # displayed on recurly
  end
end
