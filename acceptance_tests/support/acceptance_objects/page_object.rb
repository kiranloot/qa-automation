require 'capybara/cucumber'
require 'rspec/matchers'
require 'pry'
require_relative 'wait_module'
class Page
  attr_accessor :base_url, :page_type
  require 'yaml'
  include Capybara::DSL
  include RSpec::Matchers
  include WaitForAjax
  def initialize(box = Box.new(ENV['SITE']))
    @page_configs = YAML.load(File.open("acceptance_tests/support/page_configs.yml"))
    @prefix = box.prefix
    @admin = box.admin
    @page_type = 'generic'
  end

  def setup
    if !self.instance_of?(Mailinator) && !self.instance_of?(RecurlyPage) && @page_type != 'admin'
      @base_url = @prefix + @page_configs[@page_type]["url"]
    elsif @page_type == 'admin'
      @base_url = @admin
    else
      @base_url =  @page_configs[@page_type]["url"]
    end
  end

  def visit_page
    visit @base_url
    $test.current_page = self
  end

  #Keep in parent object. Used for modal and signup page logins.
  def enter_login_info(e, p)
    wait_for_ajax
    #if page.has_content?("LOGIN")
    #  page.find(:xpath, $test.test_data["locators"]["flip_member"]).click
    #end
    page.find_field('user_email')
    fill_in('user_email',:with => e )
    fill_in('user_password', :with => p)
    click_button("Log In")
    wait_for_ajax
  end

  def modal_signup(email, password, test_data)
    wait_for_ajax
    page.find_link("Log In").click
    sleep(1)
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

  def modal_forgot_password(email)
    wait_for_ajax
    find_link("Log In").click
    sleep(1)
    find_link("Forgot Password?").click
    fill_in("user_email", :with => email)
    find(:id, "reset-password-btn").click
    page.has_content?('You will receive an email with instructions on how to reset your password in a few minutes.')
  end
  
end
