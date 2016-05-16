require_relative "page_object"

class SubscribePage < Page
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "subscribe"
    setup
    @plans = {
      'one' => 'one-month',
      'three' => 'three-month',
      'six' => 'six-month',
      'twelve' => 'twelve-month'
    }
  end

  def visit_page
    visit @base_url
    $test.current_page = self
    page_scroll
  end

  def subscription_failed?(fault)
    case fault
    when "invalid credit card"
      assert_text("There was an error validating your request.")
    end
  end

  def click_get_loot
    #stub
  end

  def create_user_subscription(plan)
    $test.user.subscription = Subscription.new(plan, $test.user.crate_type)
  end

  def select_plan(plan)
    click_get_loot
    find('ol.meter')
    if plan == 'random'
      rand_key = @plans.keys.sample
      target = @plans[rand_key]
      plan = rand_key
    else
      target = @plans[plan]
    end
    find(:css, "##{target}").click
    wait_for_ajax
    rand_key ? create_user_subscription(rand_key) : create_user_subscription(plan)
    load_checkout_page_object
  end

  def load_checkout_page_object
    #stub = to be overridden by children
  end

  def verify_plan_prices(country)
    price_hash = $test.price_estimate_data[country]
    #total US price
    for month, expected_price in price_hash['us_totals']
      price = find("div.#{month}").find("p.total-price").text
      expect("Total Price: #{expected_price}").to eq (price)
    end
    #total local prices
    for month, expected_price in price_hash['local_totals']
      price = find("div.#{month}").find("p.local-total").text
      if country == "Germany"
        expect("Gesamtpreis: #{expected_price}").to eq (price)
      else
        expect("Total Price: #{expected_price}").to eq (price)
      end
    end
    #per month US prices
    for month, expected_price in price_hash['us_per_month']
      price = find("div.#{month}").find("p.plan-price").text
      expect(expected_price).to eq (price)
    end
    #per month local prices
    for month, expected_price in price_hash['local_per_month']
      price = find("div.#{month}").find("p.local-price").text
     expect("#{expected_price} /mo").to eq(price)
    end
  end

  def proration_applied?(old_plan, new_plan, date_subscribed)
    old = Plan.new(old_plan, date_subscribed, false)
    new = Plan.new(new_plan, date_subscribed, true)
  end

end
