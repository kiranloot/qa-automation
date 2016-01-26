require_relative "page_object"
require_relative "wait_module"
require "capybara/cucumber"
require "pry"
class AboutUsPage < Page
  include Capybara::DSL
  include WaitForAjax
  def initialize
    super
    @page_type = "about_us"
    setup
  end
end
