require_relative "subscribe_page_object"

class LevelUpSubscribePage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "levelup_subscribe"
    @tracking_script_lines << "lca.page('level_up', 'index', '');"
    @tracking_script_lines << "lca.clickTracking();"
    setup
    @plan_display_names = {
      'onesocks' => 'Level Up Socks 1 Month',
      'threesocks' => 'Level Up Socks 3 Month',
      'sixsocks' => 'Level Up Socks 6 Month',
      'twelvesocks' => 'Level Up Socks 12 Month',
      'oneaccessory' => 'Level Up Accessories 1 Month',
      'threeaccessory' => 'Level Up Accessories 3 Month',
      'sixaccessory' => 'Level Up Accessories 6 Month',
      'twelveaccessory' => 'Level Up Accessories 12 Month',
      'onewearable' => 'Level Up Wearable 1 Month',
      'threewearable' => 'Level Up Wearable 3 Month',
      'sixwearable' => 'Level Up Wearable 6 Month',
      'twelvewearable' => 'Level Up Wearable 12 Month',
      'onelevel-up-tshirt' => 'Level Up T-Shirt 1 Month',
      'threelevel-up-tshirt' => 'Level Up T-Shirt 3 Month',
      'sixlevel-up-tshirt' => 'Level Up T-Shirt 6 Month',
      'twelvelevel-up-tshirt' => 'Level Up T-Shirt 12 Month',
      'onelevel-up-bundle-socks-wearable-crate' => 'Level Up Bundle (socks & wearable) 1 Month',
      'threelevel-up-bundle-socks-wearable-crate' => 'Level Up Bundle (socks & wearable) 3 Month',
      'sixlevel-up-bundle-socks-wearable-crate' => 'Level Up Bundle (socks & wearable) 6 Month',
      'twelvelevel-up-bundle-socks-wearable-crate' => 'Level Up Bundle (socks & wearable) 12 Month',
      'onelevel-up-bundle-tshirt-accessories' => 'Level Up T-Shirt + Accessories Bundle 1 Month',
      'threelevel-up-bundle-tshirt-accessories' => 'Level Up T-Shirt + Accessories Bundle 3 Month',
      'sixlevel-up-bundle-tshirt-accessories' => 'Level Up T-Shirt + Accessories Bundle 6 Month',
      'twelvelevel-up-bundle-tshirt-accessories' => 'Level Up T-Shirt + Accessories Bundle 12 Month',

    }
    @recurly_plan_names = {
      'sixaccessory' => 'LC - LU - Accessory - 6 month',
      'onelevel-up-tshirt' => 'LC - LU - T-Shirt - 1 month'
    }
    @plan_drop_down_text = {
      'one' => '1 Month Plan',
      'three' => '3 Month Plan',
      'six' => '6 Month Plan',
      'twelve' => '12 Month Plan'
    }
  end

  def visit_page
    visit @base_url
    $test.current_page = self
  end

  def scroll_to(product)
    find('#lu_plans').click
    sleep(2)
    page.execute_script "window.scrollBy(0,10000)"
    expect(page).to have_css(".tips.cr-animate-gen.animated.fadeInUp")
    page.execute_script "window.scrollBy(0,-10000)"
  end

  def select_wearable_shirt_size(size)
    find('div#wearable-crate span#select2-variants-shirt-container').click
    find(:css, ".select2-results__option", :text => size).click
  end

  def select_wearable_waist_size(size)
    find('div#wearable-crate span#select2-variants-waist-container').click
    find(:css, ".select2-results__option", :text => size).click
  end

  def select_bundle_shirt_size(size)
    find('div#level-up-bundle-socks-wearable-crate span#select2-variants-shirt-container').click
    find(:css, ".select2-results__option", :text => size).click
  end

  def select_bundle_waist_size(size)
    find('div#level-up-bundle-socks-wearable-crate span#select2-variants-waist-container').click
    find(:css, ".select2-results__option", :text => size).click
  end

  def select_shirt_size(size)
    find('div#level-up-tshirt-crate span#select2-variants-shirt-container').click
    find(:css, ".select2-results__option", :text => size).click
  end

  def select_accessory_waist_size(size)
    find('#accessory-crate #select2-variants-waist-container').click
    find('.select2-results__option', :text => size).click
  end

  def select_tshirt_accessory_shirt_size(size)
    find('#level-up-bundle-tshirt-accessories-crate #select2-variants-shirt-container').click
    find('.select2-results__option', :text => size).click
  end

  def select_tshirt_accessory_waist_size(size)
    find('#level-up-bundle-tshirt-accessories-crate #select2-variants-waist-container').click
    find('.select2-results__option', :text => size).click
  end

  def create_user_subscription(plan, product)
    $test.user.subscription = LevelUpSubscription.new(plan, product)
  end

  def select_plan(product, months)
    create_user_subscription(months, product)
    scroll_to(product)
    div_id = product + '-crate'
    dd_id = 'select2-' + div_id + '-container'
    find("##{dd_id}").click
    wait_for_ajax
    #select plan
    find('ul.select2-results__options > li',:text => @plan_drop_down_text[months]).click
    if product == 'wearable'
      select_wearable_shirt_size('Mens - S')
      select_wearable_waist_size('Mens - S')
    elsif product == 'level-up-bundle-socks-wearable'
      select_bundle_shirt_size('Mens - S')
      select_bundle_waist_size('Mens - S')
    elsif product == 'level-up-tshirt'
      select_shirt_size('Mens - S')
    elsif product == 'accessory'
      select_accessory_waist_size('Womens - S')
    elsif product == 'level-up-bundle-tshirt-accessories'
      select_tshirt_accessory_shirt_size('Mens - S')
      select_tshirt_accessory_waist_size('Womens - S')
    end
    first("##{div_id}").find_link("level up").click
    wait_for_ajax
    plan = months + product
    update_target_plan(plan)
    update_recurly_plan(plan)
    load_checkout_page_object
  end

  def load_checkout_page_object
    if ENV['DRIVER'] == 'appium'
      $test.current_page = LevelUpMobileCheckoutPage.new
    else
      $test.current_page = LevelUpCheckoutPage.new
    end
  end

  def update_target_plan(plan)
    #For now, updating both level_up_subscription_name and subscription_name
    #TODO - need to get rid of level_up_subscription name and just have subscription name do all the validations
    $test.user.level_up_subscription_name = @plan_display_names[plan]
    $test.user.subscription_name = @plan_display_names[plan]
  end

  def update_recurly_plan(plan)
    $test.user.recurly_level_up_plan = @recurly_plan_names[plan]
  end

  def sold_out?(product)
    scroll_to(product)
    expect(page).to have_css("##{product}-crate h3.soldout-stamp")
    expect(page).to have_css("##{product}-crate a.soldout-description")
  end

  def level_up_variant_soldout?(variant, product)
    scroll_to(product)
    #will vary shirts/waist sizes in a different commit
    find(:div, "div#level-up-#{product}-crate span#select2-variants-shirt-container").click
    expect(find("li.select2-results__option[aria-disabled='true']", :text => variant)).to be_truthy
  end
end
