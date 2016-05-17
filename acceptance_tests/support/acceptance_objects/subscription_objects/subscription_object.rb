class Subscription
  attr_accessor :name, :months, :product, :recurly_name, :plan_title, 
                :gender, :rebill_date, :db_rebill, :recurly_rebill, :sizes,
                :billing_address, :shipping_address, :billing_info

  def initialize(months='one', product=nil)
    @months = plans[months]
    @product = product
    @sizes = {}
    set_name(@months)
    set_gender_and_sizes
    @shipping_address = nil #Pending refactor of how this info will get moved here
    @promotion = nil #Pending refactor of how this info will get moved here
    @billing_info = BillingInfo.new
    set_variant_sku
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

    year_check
  end

  def year_check
    if (@months == '12') && (@name.match(/(Anime|Gaming|Pets)/))
      @name = @name.gsub(/12 Month/, '1 Year')
    end
  end

  def upgrade_string
    if @product == 'Loot Crate'
      return @recurly_name
    else
      return @name
    end
  end

  def set_gender_and_sizes(gender=random_gender, shirt_size=random_size)
    @gender = gender
    @sizes[:shirt] = "#{@gender} - #{shirt_size}"
    @sizes[:unisex_shirt] = "Unisex - #{random_size}"
  end

  def set_rebill_info
    @rebill_date = RebillCalc.calculate_rebill_date
    @recurly_rebill = RebillCalc.get_recurly_rebill
    if (odd_cycle? && DateTime.now.day.between?(20, 27))
      @rebill_date['day'] = DateTime.now.day.to_s
      @recurly_rebill = @recurly_rebill + (Time.now.day - @recurly_rebill.day)
    end
  end

  def set_cc_num(cc_number='4111111111111111')
    @billing_info.cc_number = cc_number
    @billing_info.last_four = cc_number.split(//).last(4).join
  end

  def set_variant_sku
    #TODO: needs to be replaces with an array of skus
    #for level up and pets to work.
    puts @product
    puts @sizes[:shirt]
    @variant_sku = (@product.downcase + "-crate-" + @sizes[:shirt].downcase + "-shirt").gsub(/\s/,'')
  end

  def odd_cycle?
    /(Gaming|Anime)/.match(@product)
  end

  def sub_id
    @sub_id ||= $test.db.get_subscriptions($test.user.email).first['subscription_id']
  end

  def recurly_sub_id
    @recurly_sub_id ||= $test.recurly.get_account
  end

  def random_size(size_list='size_names')
    size_lists[size_list].sample
  end

  def random_gender
    ['Mens', 'Womens'].sample
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

  def size_lists
    {
      'size_names' => size_names,
      'pet_shirt' => pet_shirt_sizes,
      'pet_collar' => pet_collar_sizes
    }
  end

  def size_names
    ['S', 'M', 'L', 'XL', 'XXL', 'XXXL']
  end

  def pet_shirt_sizes 
    ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL']
  end

  def pet_collar_sizes
    ['S', 'M', 'L']
  end
end
