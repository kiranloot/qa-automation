require 'selenium-webdriver'
require 'capybara/cucumber'
require 'sauce/cucumber'
require 'rspec/expectations'
require 'time'

ENV['RUN_TIMESTAMP'] = Time.now().to_s

driver = ENV['DRIVER'] ||= 'local'
browser = ENV['BROWSER'] ||= 'chrome'

case driver
when 'local'
  Capybara.default_driver = :selenium
  Capybara.server_port = 10000 + ENV['TEST_ENV_NUMBER'].to_i
  Capybara.register_driver :selenium do |app|
  case browser
  when 'chrome'
    Capybara::Selenium::Driver.new(app, :browser => :chrome,)
  when 'firefox'
    Capybara::Selenium::Driver.new(app, :browser => :firefox,)
  when 'ie'
    Capybara::Selenium::Driver.new(app, :browser => :internt_explorer,)
  end
end
when 'remote'
  Capybara.default_driver = :remote_browser
  Capybara.register_driver :remote_browser do |app|
  url = ENV['REMOTE_URL'] ||= "http://127.0.0.1:4444/wd/hub"
  case browser
  when 'chrome'
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome
  when 'firefox'
    capabilities = Selenium::WebDriver::Remote::Capabilities.firefox
  when 'ie'
    capabilities = Selenium::WebDriver::Remote::Capabilities.internet_explorer
  end
  capabilities[:platform] = "MAC"
  Capybara::Selenium::Driver.new(app,
                                 :browser => :remote, :url => url,
                                 :desired_capabilities => capabilities)
  end
when 'sauce'
require 'sauce/cucumber'
  Capybara.default_driver = :sauce
  Sauce.config do |config|
    config[:start_tunnel] = true
    config[:browsers] = [
      ["OSX 10.10","Chrome",nil]
    ]
  end
end

at_exit do
  HRedis.new.kill_wait_set
end
