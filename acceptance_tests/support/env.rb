require 'selenium-webdriver'
require 'capybara/cucumber'
require 'rspec/expectations'

Capybara.default_driver = :selenium
Capybara.server_port = 10000 + ENV['TEST_ENV_NUMBER'].to_i
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome,)
end
#Capybara.ignore_hidden_elements = false
