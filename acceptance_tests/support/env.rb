require 'selenium-webdriver'
require 'capybara/cucumber'
require 'parallel_tests'
require 'rspec/expectations'
require 'time'
require_relative 'acceptance_objects/dbcon'
require_relative 'acceptance_objects/qa_env_validator'

ENV['RUN_TIMESTAMP'] = Time.now().utc.to_s
ENV['SITE'] ||= 'qa'
ENV['SERVER_CONFIGS'] ||= "#{ENV['HOME']}/server_configs.yml"
ENV['PROD_CONFIGS'] ||= "#{ENV['HOME']}/prod_configs.yml"
ENV['HEROKU_KEY'] ||= "#{ENV['HOME']}/heroku_key.yml"
ENV['WEB_DYNOS'] ||= '1'

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
      profile = { 'chromeOptions' => { 'prefs' => { 'download.default_directory' => './downloads' } } }
      Capybara::Selenium::Driver.new(app, :browser => :chrome, :desired_capabilities => profile)
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
      :platformVersion => '9.2',
      :app => 'safari'
    }
    Capybara::Selenium::Driver.new(app, {:browser => :remote, :url => "http://localhost:4723/wd/hub/", :desired_capabilities => caps})
  end
  Capybara.default_driver = :iphone

when 'appium-ios-app'
  require 'appium_capybara'
  Capybara.register_driver :iphone do |app|
    caps = {
      :deviceName => 'iPhone 6',
      :platformName => 'ios',
      :platformVersion => '9.2',
      :app => 'com.lootcrate.lootcrate',
      :uuid => 'd6e77c996570e350e5e96632f9a320fffbcd60fa'
    }
    Capybara::Selenium::Driver.new(app, {:browser => :remote, :url => "http://localhost:4723/wd/hub/", :desired_capabilities => caps})
  end
  Capybara.default_driver = :iphone
  Capybara.default_selector = :xpath
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
