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

end
