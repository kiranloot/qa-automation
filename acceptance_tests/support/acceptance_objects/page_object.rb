require 'capybara/cucumber'
require 'net/http'
require 'rspec/matchers'
require 'pry'
require_relative 'modules/wait_module'
class
Page
  attr_accessor :base_url, :page_type
  require 'yaml'
  include Capybara::DSL
  include WaitForAjax
  def initialize(box = Box.new(ENV['SITE']))
    @page_configs = YAML.load(File.open("acceptance_tests/support/page_configs.yml"))
    @prefix = box.prefix
    @admin = box.admin
    @page_type = 'generic'
    @tracking_script_lines = []
    @conversion_tracking_script_lines = []
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

  def no_errors?
    expect(page).to have_no_selector('div.error-page-404')
    expect(page).to have_no_selector('div.error-page-500')
  end

  def click_logo
    find('#header-logo-lnk').click
  end

  def log_out
    click_logo
    if ENV['DRIVER'] == 'appium'
      find(".navbar-toggle").click
      wait_for_ajax
    end
    click_link("My Account")
    click_link("Log Out")
    wait_for_ajax
  end

  def is_logged_in?
    click_logo
    assert_text("My Account")
  end

  def click_hamburger
    find(:css, 'button.navbar-toggle').click
  end

  def page_scroll(counter=2)
    counter.times do
      find(".loaded")
      page.execute_script "window.scrollBy(0,10000)"
      wait_for_ajax
    end
  end

  def modal_signup(email, password)
    wait_for_ajax
    find_link("Log In").click
    sleep(1)
    find_link("Forgot Password?")
    find_link("Join")
    page.has_content?("Welcome Back!")
    find('#signin_modal > div > div > div.modal-footer > p > a').click
    page.has_content?("Join the Looter community!")
    fill_in("new_user_email_modal", :with => email)
    find_field("new_user_email_modal").value
    find_link("finish_step_one").click
    fill_in("new_user_password_modal",:with => password)
    find_button("create_account_modal").click
    wait_for_ajax
  end

  def modal_forgot_password(email)
    wait_for_ajax
    find_link("Log In").click
    sleep(1)
    find_link("Forgot Password?").click
    fill_in("user_email", :with => email)
    find(:id, "reset-password-btn").click
    wait_for_ajax
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

  def footer_email_signup
    test = page.find(:id, 'footer-mce-email')
    puts test
  end

  def check_link_integrity
    wait_for_ajax
    #Gather all links on the page
    all_links = page.all(:css, 'a')
    exclusions = ['play.google.com', 'youtube.com', 'thedailycrate.com']

    all_links.each do |a|
      uri = URI(a[:href])
      #Skip Google/Youtube links due to SSL constraint. Must manually test for now.
      # TODO: Research a solution to the SSL issue
      if exclusions.any? { |word| a[:href].include?(word) }
        #skip
      else
        # puts 'Checking ' + a[:href] + ' ...'
        resp = Net::HTTP.get_response(uri)

        # TODO: Research a better solution for 301 and 302 redirect response codes.
        expect(["200", "301", "302"]).to include(resp.code), "Link to #{a[:href]} returned response code: #{resp.code}"
      end
    end
  end

  def tracking_partial_exists?
    lines = [
        "var lca_user = {};",
        "var lca = LC_Analytics(lca_user);",
        "lca.anonIdCookie();",
        #"lca.trackInitialPlan();",
        "lca.activeSubsCookie();",
        "lca.alias();",
        "lca.identify();"
    ]
    #will append variable lines to the above based on the page we are visiting
    lines += @tracking_script_lines
    lines.each do |line|
      expect(html).to include(line), "Did not find tracking line:'#{line}' in the html."
    end
  end

  def conversion_tracking_partial_exists?
    #will assume this is for a 1 months california sub
    #will also make some fields "incomplete" for validation later
    #will make this variable in a later revision
    lines = [
      "analytics.track('Completed Order', {",
      "orderId:",
      "total: 21.75,",
      "revenue: 19.95,",
      "tax: 1.80,",
      "discount: 0.00,",
      "currency: 'USD',",
      "repeatPurchase: false,",
      "planName: '1-month-subscription',",
      "planCountry: 'US',",
      "planPrice: 19.95,",
      #"initialPlan: LC_Analytics().getInitialPlan(),",
      "shippingCountry: 'US',",
      "productName: 'Core Crate',",
      "paymentMethod: 'credit card',",
      "productBrand: 'Loot Crate Core',",
      "paymentMethod: 'credit card',",
      "products: [",
      "id: 'core-crate-1',",
      "sku: '1-month-subscription',",
      "name: 'Core Crate',",
      "price: 19.95,",
      "quantity: 1,",
      "category: 'Loot Crate Core',",
      "brand: 'Loot Crate Core'",
      "var dataLayer = dataLayer || [];",
      "dataLayer.push({utmSource: ''})",
    ]
    lines += @conversion_tracking_script_lines
    lines.each do |line|
      expect(html).to include(line), "Did not find conversion tracking line:'#{line}' in the html."
    end
  end
  #Jose trailing slash automation
  def home_page_nav_append_slash
    @trail_url = @base_url + "/"
    visit(@trail_url)
  end

  def redirect_no_trailing_slash?
    wait_for_ajax()
    expect(page.current_url).to eq(@base_url)
  end
end
