ENV['SERVER_CONFIGS'] ||= "#{ENV['HOME']}/server_configs.yml"
ENV['PROD_CONFIGS'] ||= "#{ENV['HOME']}/prod_configs.yml"

require 'selenium-webdriver'
require 'capybara/cucumber'
require 'parallel_tests'
require 'time'
require_relative 'acceptance_objects/modules/qa_env_validator'
require_relative 'acceptance_objects/modules/inventory_flag_manager'

ENV['RUN_TIMESTAMP'] = Time.now().utc.to_s
ENV['SITE'] ||= 'qa'
ENV['CACHE_CLEAR'] ||= 'yes'
ENV['MAIL_CHECK'] ||= 'yes'

driver = ENV['DRIVER'] ||= 'local'
browser = ENV['BROWSER'] ||= 'chrome'

if ParallelTests.first_process?
  require_relative 'acceptance_objects/dbcon'
  conn = DBCon.new
  conn.setup_qa_database
  conn.finish

  if ENV['CACHE_CLEAR'] == 'yes'
    require_relative 'acceptance_objects/memcachier_object'
    require_relative 'acceptance_objects/fastly_object'
    HerokuAPI.new.clear_rails_cache
    puts 'Rails cache flushed.'

    memcache = Memcachier.new
    memcache.flush
    puts 'Memcachier cache flushed.'

    FastlyAPI.new.purge_cache
    puts 'Fastly cache purged'
  end
  #Sets inventory flags so that sellout tests don't sell out inventory being used
  InventoryFlagManager.set_all_flags
  HerokuAPI.new.enable_webhook_dynos
end

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
 if ParallelTests.number_of_running_processes <= 1
  HerokuAPI.new.disable_webhook_dynos
  require_relative 'acceptance_objects/memcachier_object'
  memcache = Memcachier.new
  memcache.flush
 end
 logtime['end'] = DateTime.now.strftime('%Q')
 puts 'this is the end'
 LogMonitor.new.get_errors_log(logtime['start'], logtime['end'])
 r = HRedis.new
 r.connect
 r.kill_wait_set
 r.quit
end
