require_relative "page_object"
require_relative "modules/wait_module"
require "capybara/cucumber"
require "pry"
class PewdiepiePage < Page
  include Capybara::DSL
  include WaitForAjax
  def initialize
    super
    @page_type = "pewdiepie"
    setup
  end

  
end