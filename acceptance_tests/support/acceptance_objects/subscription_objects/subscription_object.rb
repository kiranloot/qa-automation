class Subscription
  attr_accessor :name, :months, :product, :shirt_size, :waist_size, :recurly_name, :plan_title, :gender, :rebill_date, :recurly_rebill

  def initialize(months='one', product=nil)
    @months = plans[months]
    @product = product
    set_name(@months)
    set_gender_and_sizes
  end

  def set_name(months)
    case @product
    when 'Pets'
      @name = "Pets #{months} Month Subscription"
    when 'Anime'
      @name = "Anime #{months} Month Subscription"
    when 'Firefly'
      @name = "#{months} Month Plan Subscription"
    when 'Gaming'
      @name = "Gaming #{months} Month Subscription"
    when 'Lcdx'
      @name = "Lcdx #{months} Month Subscription"
    else
      @name = "#{months} Month Plan Subscription"
    end

    if @product == "Loot Crate"
      @recurly_name = "#{months} Month Subscription"
    else
      @recurly_name = @name
    end

    year_check(@name)
  end

  def year_check(name)
    if (@months == '12') && (name.match(/(Anime|Gaming|Pets)/))
      name.gsub!(/12 Month/, '1 Year')
    end
  end

  def upgrade_string
    if @product == 'Loot Crate'
      return @recurly_name
    else
      return @name
    end
  end

  def set_gender_and_sizes(gender='womens', shirt_size ='s', waist_size='s')
    @gender = gender
    @shirt_size = shirt_size
    @waist_size = waist_size
  end

  def set_rebill_info
    @rebill_date = $test.calculate_rebill_date
    @recurly_rebill = $test.recurly.get_rebill_date
    if (odd_cycle? && DateTime.now.day.between?(20, 27))
      @rebill_date['day'] = DateTime.now.day.to_s
      @recurly_rebill = @recurly_rebill + (Time.now.day - @recurly_rebill.day)
    end
  end

  def odd_cycle?
    /(Gaming|Anime)/.match(@product)
  end

  private
  def plans
    {
      'one' => '1',
      'two' => '2',
      'three' => '3',
      'six' => '6',
      'twelve' => '12'
    }
  end
end
