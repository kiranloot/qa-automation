require_relative "subscribe_page_object"

class LevelUpSubscribePage < SubscribePage
  include Capybara::DSL
  include WaitForAjax

  attr_accessor :crate, :months

  def initialize
    super
    @page_type = "levelup_subscribe"
    @tracking_script_lines << "lca.page('level_up', 'index', '');"
    @tracking_script_lines << "lca.clickTracking();"
    setup

    @plan_header_text = {
      'one' => '1 month',
      'three' => '3 months',
      'six' => '6 months',
      'twelve' => '12 months'
    }

    @crate_names_and_labels = {
      'for her' => 'Get Loot for Her',
      'socks' => 'Get Loot Socks',
      'tees' => 'Get Loot Tees',
      'wearables' => 'Get Loot Wearables',
      'socks + wearable' => 'Socks + Wearable',
      'for her + tee' => 'For Her + Tee'
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

  def load_checkout_page_object
    if ENV['DRIVER'] == 'appium'
      $test.current_page = LevelUpMobileCheckoutPage.new
    else
      $test.current_page = LevelUpCheckoutPage.new
    end
  end

  def sold_out?
    expect(page).to have_css("#btn-info-soldout")
    expect(page).to have_css("#btn-info-soldout-notify")
  end

  def choose_bundle(crate, bundle=false)
    @crate = crate
    if bundle
      panel = find('h2', :text => @crate_names_and_labels[crate].upcase).find(:xpath, '..')
      panel.find_link('Get Bundle').click
    else
      find_link(@crate_names_and_labels[crate]).click
    end
    wait_for_ajax
  end

  def choose_duration(months)
    @months = months
    find('h3.title', :text => @plan_header_text[months].upcase)
      .find(:xpath, '..').find('button').click
    build_subscription(@months, @crate)
    wait_for_ajax
  end

  def build_subscription(months, crate)
    $test.user.subscription = LevelUpSubscription.new(months, crate)
    $test.user.subscription_name = $test.user.subscription.name
  end

  def choose_sizes(subscription)
    unless subscription.product == 'socks'
      size_section = find("section#section-lu-sizes")
      find("#sizes-btn-#{subscription.gender}").click if size_section.text.include?('MENS WOMENS')
      find("#sizes-btn-shirt-#{subscription.gender}-#{subscription.shirt_size}").click if size_section.text.include?('SHIRT SIZE')
      find("#sizes-btn-waist-womens-#{subscription.waist_size}").click if size_section.text.include?('WAIST SIZE')
      wait_for_ajax
    end
  end

  def continue_to_checkout
    if $test.user.subscription.product == 'socks'
      find('#plans-btn-next').click
    else
      find("#sizes-btn-next").click
    end
    load_checkout_page_object
  end




  ##### Legacy Level Up Methods #####

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

  def update_target_plan(plan)
    #For now, updating both level_up_subscription_name and subscription_name
    #TODO - need to get rid of level_up_subscription name and just have subscription name do all the validations
    $test.user.level_up_subscription_name = @plan_display_names[plan]
    $test.user.subscription_name = @plan_display_names[plan]
  end

  def update_recurly_plan(plan)
    $test.user.recurly_level_up_plan = @recurly_plan_names[plan]
  end

  def level_up_variant_soldout?(variant, product)
    scroll_to(product)
    #will vary shirts/waist sizes in a different commit
    find(:div, "div#level-up-#{product}-crate span#select2-variants-shirt-container").click
    expect(find("li.select2-results__option[aria-disabled='true']", :text => variant)).to be_truthy
  end
end
