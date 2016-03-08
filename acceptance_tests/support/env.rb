require 'selenium-webdriver'
require 'capybara/cucumber'
require 'parallel_tests'
require 'rspec/expectations'
require 'time'
require_relative 'acceptance_objects/dbcon'
require_relative 'acceptance_objects/qa_env_validator'

ENV['RUN_TIMESTAMP'] = Time.now().utc.to_s
ENV['SITE'] ||= 'qa4'

driver = ENV['DRIVER'] ||= 'local'
browser = ENV['BROWSER'] ||= 'chrome'

conn = DBCon.new
ParallelTests.first_process? ? conn.setup_qa_database : sleep(1)
conn.finish

#Verification that config vars on the test environment don't point to prod
QAEnvironmentValidator.verify

logtime = {'start' => DateTime.now.strftime('%Q')}

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
    when 'safari'
      Capybara::Selenium::Driver.new(app, :browser => :safari,)
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
when 'appium'
  require 'appium_capybara'
  Capybara.register_driver :iphone do |app|
    caps = {
      :deviceName => 'iPhone 6',
      :platformName => 'ios',
      :version => '9.2',
      :app => 'safari'
    }
    Capybara::Selenium::Driver.new(app, {:browser => :remote, :url => "http://localhost:4723/wd/hub/", :desired_capabilities => caps})
  end
  Capybara.default_driver = :iphone
end

at_exit do
 logtime['end'] = DateTime.now.strftime('%Q')
 puts 'this is the end'
 LogMonitor.new.get_errors_log(logtime['start'], logtime['end'])
 r = HRedis.new
 r.connect
 r.kill_wait_set
 r.quit
end
