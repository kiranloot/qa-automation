require 'capybara/cucumber'
require 'net/http'
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
    @tracking_script_lines = []
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

  def wait_for_modal
    sleep(20)
    find(:id, 'wf-newsletter-modal', :visible => true)
    $test.current_page = self
  end

  def newsletter_modal_signup(email)
    # fill_in('modal-mce-email', :with => email)
    find('#modal-mce-email').send_keys(email)
    find_button('modal-mc-embedded-subscribe').click
    wait_for_ajax
  end

  def check_link_integrity
    wait_for_ajax
    #Gather all links on the page
    all_links = page.all(:css, 'a')

    # #Create http object
    # http = Net::HTTP.new(a[:href])

    all_links.each do |a|
      uri = URI(a[:href])
      #Skip Google/Youtube links due to SSL constraint. Must manually test for now.
      # TODO: Research a solution to the SSL issue
      if a[:href].include?('play.google.com')
      elsif a[:href].include?('youtube.com')
      else
        resp = Net::HTTP.get_response(uri)

        # TODO: Research a better solution for 301 and 302 redirect response codes.
        expect(["200", "301", "302"]).to include(resp.code)
        puts "#{a[:href]}\nResponse Code: #{resp.code}\n"
      end
    end

  def tracking_partial_exists?(type)
    script_lines = {
      'tracking' => [
        "var lca_user = {};",
        "var lca = LC_Analytics(lca_user);",
        "lca.anonIdCookie();",
        "lca.trackInitialPlan();",
        "lca.activeSubsCookie();",
        "lca.alias();",
        "lca.identify();"
        #"lca.clickTracking();"
      ]
    }
    lines = script_lines[type]
    #will append variable lines to the above based on the page we are visiting
    lines += @tracking_script_lines 
    lines.each do |line|
      expect(html).to include(line)
    end
  end
end
