require_relative "page_object"

class UpgradePage < Page
  include Capybara::DSL

  def initialize
    super
    @page_type = 'upgrade'
  end

  def visit_page
    visit $env_base_url
    click_link('My Account')
    click_link('Manage Account')
    click_link('Subscriptions')
    first(:link, 'Upgrade').click
    $test.current_page = self
  end

  def get_displayed_value(type)
    # should be 'product price', 'prorated amount' or 'payment due'
    type = type.capitalize + ':'
    
    node = find(:xpath, "//*/text()[normalize-space(.)='#{type}']/following::li[1]")

    node.text
  end

  def get_expected_value(type)
    #assumes US shipment
    state = $test.user.ship_state
    current_plan = $test.user.plan_months
    plan_cost = if state == 'CA'
        $test.plan_cost_test_data['ca_plan_cost']
      else
        $test.plan_cost_test_data['plan_cost']
      end

    case type
    when 'product price'
      "$#{plan_cost[selected_upgrade]}"
    when 'prorated amount'
      "-$#{plan_cost[current_plan]}"
    when 'payment due'
      "$#{plan_cost[selected_upgrade] - plan_cost[current_plan]}"
    else
      puts 'Invalid type value'
      nil
    end
  end

  def selected_upgrade
    node = find(:xpath, "//select/option[@selected='selected']")
    node.text.gsub(/[^\d]/, '').to_i
  end
end
