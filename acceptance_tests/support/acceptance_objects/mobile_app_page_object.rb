require 'capybara/cucumber'
require 'net/http'
require 'rspec/matchers'
require 'pry'
require_relative 'modules/wait_module'
class MobileAppPage
  require 'yaml'
  include Capybara::DSL
  include RSpec::Matchers
  include WaitForAjax
  def initialize
  end

  def hide_keyboard
    find("//UIAButton[contains(@name,'Done')]").click
  end

  def is_on_the_feed_page?
    page.has_xpath?("//UIANavigationBar[contains(@name,'Feed')]")
  end

  def nav_bar_visible?
    page.has_xpath?("//UIATabBar")
  end

  def click_on_token_alert
    find("//UIAApplication[1]/UIAWindow[5]/UIAAlert[1]/UIACollectionView[1]").click
  end
end
