require_relative "page_object"

class ExpressCheckoutPage < Page
include Capybara::DSL
  def initialize
    super
    url = current_url
    @base_url = url.gsub(/checkouts/,'express_checkouts')
  end

  def visit_page
    visit @base_url
    $test.current_page = self
  end
end
