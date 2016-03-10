require_relative "subscribe_page_object"

class CallofdutyLandingPage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "call_of_duty_landing"
    setup

  end

  def visit_page
    visit @base_url
    $test.current_page = self
  end

end