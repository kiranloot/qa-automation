require_relative "subscribe_page_object"
require_relative "ship_cycle_checker"

class LandingPage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "landing"
    @tracking_script_lines << "lca.page('core_crates', 'show', '');"
    setup
  end

  def click_get_loot
    #stub
  end

  def load_checkout_page_object
    #stub
  end

  def check_countdown_timer
    page_scroll
    if ShipCycleChecker.before_shipping_cutoff?($test.user.crate_type)
      verify_timer_counting
    else
      verify_timer_shipping
    end
  end

  def verify_timer_shipping
    page_scroll
    expect(find("#dday").text).to eq("SH")
    expect(find("#dhour").text).to eq("IP")
    expect(find("#dmin").text).to eq("PI")
    expect(find("#dsec").text).to eq("NG!")
  end
end
