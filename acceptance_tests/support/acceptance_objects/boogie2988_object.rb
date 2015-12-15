require_relative "page_object"
require_relative "wait_module"
require "capybara/cucumber"
require "pry"
class Boogie2988Page < Page
  include Capybara::DSL
  include WaitForAjax
  def initialize
    super
    @page_type = "boogie2988"
    setup
  end

  
end