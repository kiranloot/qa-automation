require_relative "page_object"
require_relative "modules/wait_module"
require "capybara/cucumber"
require "pry"
class HomePage < Page
  include Capybara::DSL
  include WaitForAjax
  def initialize
    super
    @page_type = "home"
    #additional lines to check for during the segment tests
    @tracking_script_lines << "lca.page('homepage', 'index', '');"
    @tracking_script_lines << "lca.clickTracking();"
    setup
  end

  def visit_with_affiliate(affiliate_name)
    affiliate_url = @prefix + "/" + affiliate_name
    visit affiliate_url
  end

  def newsletter_signup(email)
    find(:id,'footer-mce-email').click
    fill_in('email', :with => email)
    find(:id,'footer-mc-embedded-subscribe').click
  end

end
