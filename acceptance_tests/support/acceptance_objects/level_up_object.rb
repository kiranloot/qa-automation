require_relative "page_object"

class LevelUpPage < Page
include Capybara::DSL

  def initialize
    super
    @page_type = "level_up"
    setup
  end

  def scroll_to(product)
    case product
    when 'socks'
      scroll_val = 1050
    when 'accessory'
      scroll_val = 1550
    when 'wearable'
      scroll_val = 2050
    end
    page.execute_script "window.scrollBy(0,#{scroll_val})"
    sleep(1)
  end

  def select_level_up(product,months,size = nil)
    #determine scroll distance and div to look at
    $test.user.target_level_up_plan(product,months)
    scroll_to(product)
    #click on dropdown
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

  def sold_out?(product)
    scroll_to(product) 
    expect(page).to have_css("##{product}-crate h3.soldout")
    expect(page).to have_css("##{product}-crate a.soldout-description")
  end
end
