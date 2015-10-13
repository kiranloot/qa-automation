require 'yaml'
require 'pry'
require 'factory_girl'
require 'active_support'
require 'rspec/expectations'
require 'platform-api'
Dir["acceptance_objects/*"].each do |file|
  puts file
  require file
end

ENV['ASPECTOR_LOG_LEVEL'] = 'NONE'

env = ENV['SITE']

box = Box.new(env)

$env_base_url = box.base_url

$env_test_data_file_path ||= "acceptance_tests/support/qa_test_data.yml"
test_data = YAML.load(File.open($env_test_data_file_path))
pages = {home: HomePage, signup: SignupPage, checkout: CheckoutPage, subscribe: SubscribePage,
            my_account: MyAccountPage, mailinator: Mailinator, admin: AdminPage, upgrade: UpgradePage,
         recurly: RecurlyPage, level_up: LevelUpPage, express_checkout: ExpressCheckoutPage, fallout4:Fallout4Page}

Before do
  Capybara.default_wait_time = 15
  Capybara.use_default_driver
  page.driver.browser.manage.window.move_to(0, 0)
  page.driver.browser.manage.window.resize_to(1800, 1100)
  visit $env_base_url
  $test = Test.new( test_data, HomePage.new, pages, DBCon.new, box)
  $test.user = User.new($test)
end

After do
  $test.db.finish
  reset_session!
  page.execute_script "window.close();"
end
