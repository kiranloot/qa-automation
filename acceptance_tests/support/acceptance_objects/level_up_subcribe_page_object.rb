require_relative "subscribe_page_object"

class LevelUpSubscribePage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "levelup_subscribe"
    setup
    @plans = {}
  end

  def visit_page
    visit @base_url 
    $test.current_page = self
  end

  def click_thru_to_plan_selection
    click_button("level up").click
    sleep(2)
    scroll_val = 500 
    page.execute_script "window.scrollBy(0,#{scroll_val})"
  end

  def select_plan(product, months)
    scroll_to(product)
    div_id = product + '-crate'
    dd_id = 's2id_' + div_id
    find(:id,dd_id).click
    wait_for_ajax
    case months
    when "one"
      plan_index = '1'
    when "three"
      plan_index = '2'
    when "six"
      plan_index = '3'
    end
    #select plan
    find(:css,'ul.select2-results').find(:xpath,"li[#{plan_index}]").click
    verify_level_up_plan_price(product, months, div_id)
    #click subscribe
    find(:id,div_id).find_link("level up").click
    wait_for_ajax
    update_target_plan(plan)
    load_chekckout_page_object
  end

  def update_target_plan(plan)
    plan_hash = {
      
    }
  end
end
