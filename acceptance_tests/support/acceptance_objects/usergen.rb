class UserGen

  def initialize(type, arg_string)
    arg_string.downcase! if arg_string
    parse_args(type, arg_string) if arg_string
    set_simple(type) unless arg_string
  end

  def parse_args(t, arg_string)
    @location_trait = false
    @month_trait = false
    @args = preprocess(arg_string)
    if @args.class == String
      @args = @args.split(" ")
      @args = @args.join("_")
    end
    @type = t
    @location_trait || @month_trait ? @trait = @args : @trait = self.send(@args)
  end

  def set_simple(type)
    @type = type
  end

  def preprocess(args)
    ret = args
    a = address_check(args)
    m = months_check(args)
    ret = is_address(a[1].tr(' ', '')) if a
    @location_trait = true if a
    ret = months(m[1].tr('^a-z', '_')) if m
    @month_trait = true if m
    ret
  end

  def address_check(args)
    a = /an? (.*?) address/.match(args)
    a
  end

  def is_address(place)
    address_trait(place)
  end

  def months_check(args)
    m = /an? (.*?) month subscription/.match(args)
    m
  end

  def address_trait(country)
    if country == "random"
      #stub
    else
      return country.to_sym
    end
  end

  def rand_val(possibilities)
    possibilities[rand()]
  end

  def no_prior_subscription
    :registered_no_prior
  end

  def a_multi_use_fixed_promo_code
    :multi_use_fixed_promo
  end

  def a_one_time_use_percentage_promo_code
    :one_time_use_percentage_promo
  end

  def months(number)
    (number + "_month").to_sym
  end

  def access_to_their_info
    :subject_user
  end

  def a_canceled_subscription
    :canceled
  end

  def an_active_subscription
    :registered_with_active
  end

  def an_active_subscription_last_month
    :registered_with_active_last_month
  end

  def an_active_anime_subscription
    :registered_with_active_anime
  end

  def an_active_gaming_subscription
    :registered_with_active_gaming
  end

  def an_active_firefly_subscription
    :registered_with_active_firefly
  end

  def an_active_level_up_subscription
    :registered_with_active_level_up
  end

  def an_active_pets_subscription
    :registered_with_active_pets
  end

  def an_active_dx_subscription
    :registered_with_active_dx
  end

  def an_active_subscription_with_tracking_information
    :registered_with_active_and_tracking
  end

  def an_international_one_month_subscription
    :international_one_month
  end

  def simple_registered
    FactoryGirl.build(:user, :registered)
  end

  def simple_unregistered
    FactoryGirl.build(:user)
  end

  def simple_alchemy
    $test.cms_user = FactoryGirl.build(:user, :alchemy)
    $test.user
  end

  def admin_and_subject
    #hack, will fix/remove this later
    $test.admin_user = simple_admin
    $test.user
  end

  def simple_admin
    u = FactoryGirl.build(:user, :admin)
    u
  end

  def get_user_from_db(type, trait)
    db = DBCon.new
    db.respond_to?(trait) ? result = db.send(trait) : result = nil
    if result && result["email"] != nil
      u = User.new($test)
      u.configure_from_input(result)
      u.need_sub = false
      db.finish
      return u
    else
      db.finish
      return nil
    end
  end

  def build
  #  u = nil
    if @trait
      u = get_user_from_db(@type, @trait)
      unless u
        u =  FactoryGirl.build(:user, @trait) if (@type != "admin")
        u = admin_and_subject if @trait == :subject_user && @type == "admin"
      end
    else
      u = self.send("simple_"+ @type)
    end
    u.trait = @trait
    u
  end
end
