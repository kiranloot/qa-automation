require_relative "subscribe_page_object"

class LevelUpSubscribePage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "levelup_subscribe"
    setup
    @plan_display_names = {
      'onesocks' => 'Level Up Socks 1 Month',
      'threesocks' => 'Level Up Socks 3 Month',
      'sixsocks' => 'Level Up Socks 6 Month',
      'twelvesocks' => 'Level Up Socks 12 Month',
      'oneaccessory' => 'Level Up Accessories 1 Month',
      'threeaccessory' => 'Level Up Accessories 3 Month',
      'sixeaccessory' => 'Level Up Accessories 6 Month',
      'twelveaccessory' => 'Level Up Accessories 12 Month'
    }
    @plan_drop_down_index = {
      'one' => 1,
      'three' => 2, 
      'six' => 3,
      'twelve' => 4
    }
  end

  def visit_page
    visit @base_url 
    $test.current_page = self
  end 

  def scroll_to(product)
    click_link("Level Up")
    sleep(2)
    case product
    when 'socks'
      scroll_val = 0
    when 'accessory'
      scroll_val = 500
    when 'wearable'
      scroll_val = 750
    end
    page.execute_script "window.scrollBy(0,#{scroll_val})"
  end

  def select_plan(product, months)
    scroll_to(product)
    div_id = product + '-crate'
    dd_id = 's2id_' + div_id
    find(:id,dd_id).click
    wait_for_ajax
    #select plan
    find(:css,'ul.select2-results').find(:xpath,"li[#{@plan_drop_down_index[months]}]").click
    find(:id,div_id).find_link("level up").click
    wait_for_ajax
    plan = months + product
    update_target_plan(plan)
    load_checkout_page_object
  end

  def load_checkout_page_object 
    $test.current_page = LevelUpCheckoutPage.new
  end

  def update_target_plan(plan)
    $test.user.level_up_subscription_name = @plan_display_names[plan]
    $test.user.subscription_name = @plan_display_names[plan]
  end

  def sold_out?(product)
    scroll_to(product)
    expect(page).to have_css("##{product}-crate h3.soldout")
    expect(page).to have_css("##{product}-crate a.soldout-description")
  end
end
