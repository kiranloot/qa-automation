require 'selenium-webdriver'
require 'capybara/cucumber'
require 'parallel_tests'
require 'rspec/expectations'
require 'time'
require_relative 'acceptance_objects/dbcon'

ENV['RUN_TIMESTAMP'] = Time.now().utc.to_s
ENV['SITE'] ||= 'qa'

driver = ENV['DRIVER'] ||= 'local'
browser = ENV['BROWSER'] ||= 'chrome'

conn = DBCon.new
ParallelTests.first_process? ? conn.setup_qa_database : sleep(1)
conn.finish

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
 r = HRedis.new
 r.connect
 r.kill_wait_set
 r.quit
end
