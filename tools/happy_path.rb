
# Happy Path Scenario

# This script is meant
# Instructions:
# Load this baby up!
Capybara.current_driver = :selenium
login_page = LoginPageObject.new(base_uri: 'http://localhost:3000')
user = FactoryGirl.build(:user,
  email:  DateTime.now.strftime("jeffects%Y%m%d%H%M@mailinator.com"),
  full_name: 'Jeffects Testcase',
  password: 'password'
)

login_page.visit_join_page
login_page.click_one_month
login_page.register user

subscription_page = NewSubscriptionPageObject.new(user: user)
subscription_page.fill_in_account_info
subscription_page.fill_in_shipping_info
subscription_page.fill_in_billing_info
subscription_page.fill_in_credit_card
subscription_page.click_subscribe

