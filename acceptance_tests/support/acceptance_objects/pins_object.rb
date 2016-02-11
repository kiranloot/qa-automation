require_relative "page_object"

class PinsPage < Page
include Capybara::DSL

  def initialize
    super
    @page_type = "pins"
    setup
  end

  def login_to_redeem_button_visible?
    page.has_content?("LOG IN TO REDEEM") 
  end

  def select_qualified_subscription(name, monthyear)
    monthyear.downcase! 
    find("#select2-#{monthyear}-container").click
    wait_for_ajax
    find(".select2-results__option", :text => name).click
  end

  def code_displayed?
    assert_text($test.user.pin_code)
  end

end
