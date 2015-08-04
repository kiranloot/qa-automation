require_relative "page_object"

class SkipPage < Page
include Capybara::DSL

  def initialize
    super
    @page_type = "skip"
  end

  def click_skip
    find_link("SKIP A MONTH").click
    wait_for_ajax
  end
end
