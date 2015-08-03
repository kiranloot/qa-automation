require 'selenium-webdriver'
require 'capybara/cucumber'
require 'rspec/expectations'
require 'time'

ENV['RUN_TIMESTAMP'] = Time.now().to_s

Capybara.default_driver = :selenium
Capybara.register_driver :selenium do |app|
Capybara::Selenium::Driver.new(app, :browser => :chrome,)
end

at_exit do
  HRedis.new.kill_wait_set
end
