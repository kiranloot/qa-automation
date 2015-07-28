require_relative "page_object"

class LevelUpPage < Page
include Capybara::DSL

  def initialize
    super
    @page_type = "level_up"
    setup
  end

  def select_level_up(product,months,size = nil)
    #determine scroll distance and div to look at
    $test.user.target_level_up_plan(product,months)
    if product == 'socks'
      scroll_val = 750
      div_id = 'socks-crate'
    elsif product == 'accessory'
      scroll_val = 1250
      div_id = 'accessory-crate'
    elsif product == 'wearable'
      scroll_val = 1750
      div_id = 'wearable-crate'
    end
    for i in 0..2
      if page.has_content?("LEVEL UP YOUR LOOT")
        break
      end
    end
    page.execute_script("window.scrollBy(0,#{scroll_val})")
    #select a plan
    if months == 'one'
      find(:id,div_id).find(:css,'div.select2-container').click
      find(:css,'ul.select2-results').find(:xpath, 'li[1]').click
    elsif months == 'six'
      find(:id,div_id).find(:css,'div.select2-container').click
      find(:css,'ul.select2-results').find(:xpath, 'li[3]').click
    end
    verify_level_up_plan_price(product, months, div_id)
    #click subscribe
    find(:id,div_id).find_link("SUBSCRIBE").click
  end

  def verify_level_up_plan_price(product, months, div_id)
    expected_cost = $test.test_data['level_up_plan_cost'][product][months]
    expected_cost = "Total Price: $" + expected_cost.to_s
    for i in 0..2
      if page.has_content?(expected_cost)
        break
      end
    end
    actual_cost = find(:id,div_id).find(:div,'p.total-cost').text
    expect(actual_cost).to eq(expected_cost)
  end
end
