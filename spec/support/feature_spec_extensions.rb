# from http://ruby-journal.com/how-to-switch-between-selenium-and-poltergeist-for-rails-integration-rsped-test/
module FeatureSpecExtensions
  def hang
    print "Waiting.... Press return if you wanna continue"

    if ENV['FF'] == 'true'
      STDIN.getc
    else
      page.driver.debug
    end
  end
end

RSpec.configure do |config|
  config.include FeatureSpecExtensions, type: :feature

  config.before :each, {type: :feature} do
    if ENV['FF'] == 'true' # in case you wanna run it with selenium
      require 'selenium-webdriver'
      Capybara.current_driver = :selenium
    else
      require 'capybara/poltergeist'
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {
          js_errors: true,
          inspector: true,
          phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'],
          timeout: 120
        })
      end
    end
  end

  config.before :each, {type: :feature, js: true} do
    Capybara.current_driver = ENV['FF'] == 'true' ? Capybara.javascript_driver : :poltergeist
  end

  browser = Capybara.current_session.driver.browser
  if browser.respond_to?(:clear_cookies)
    # Rack::MockSession
    browser.clear_cookies
  elsif browser.respond_to?(:manage) and browser.manage.respond_to?(:delete_all_cookies)
    # Selenium::WebDriver
    browser.manage.delete_all_cookies
  else
    raise "Don't know how to clear cookies. Weird driver?"
  end
end
