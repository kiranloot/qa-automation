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

  def request_password_reset
    tolerance = 2
    for i in 0..tolerance do
      if page.has_content?("MONTHLY") && page.has_content?("Order")
        page.find_link("Log In").click
        if page.has_content?("Welcome Back!")
          break
        end
      end
    end
    find_link("Forgot Password?").click
    find_field("user_email")
    fill_in("user_email", :with => $test.user.email)
    find_button("RESET PASSWORD").click
    $test.user.toggle_password
  end
  
end
