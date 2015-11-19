require_relative "page_object"

class LootcrateSubscribePage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "lootcrate_subscribe"
    setup
  end

  def visit_page
    visit @base_url 
    $test.current_page = self
  end

  def load_checkout_page_object
    $test.current_page = LootcrateCheckoutPage.new
  end
end
