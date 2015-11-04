require_relative "page_object"
require_relative "wait_module"
require "capybara/cucumber"
require "pry"
class HomePage < Page
  include Capybara::DSL
  include WaitForAjax
  def initialize
    super
    @page_type = "home"
    setup
  end

  def visit_with_affiliate(affiliate_name)
    affiliate_url = @prefix + "/" + affiliate_name
    visit affiliate_url
  end

  def modal_signup(email, password, test_data)
    wait_for_ajax
    page.find_link("Log In").click
    page.find_link("Forgot Password?")
    page.find_link("Join")
    page.has_content?("Welcome Back!")
    page.find(:css, test_data["locators"]["modal_join"]).click
    page.has_content?("Join the Looter community!")
    fill_in("new_user_email_modal", :with => email)
    page.find_field("new_user_email_modal").value
    page.find_link("finish_step_one").click
    fill_in("new_user_password_modal",:with => password)
    page.find_button("create_account_modal").click
  end
end
