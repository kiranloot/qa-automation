require 'spec_helper'

feature 'Visitor signs up for a subscription', js: true do
  background do
    create_default_plans
    @visitor = FactoryGirl.build(:user,
      email:  DateTime.now.strftime("jeffects%Y%m%d%H%M@mailinator.com"),
      full_name: 'Jeffects Testcase',
      password: 'password'
    )
  end

  scenario 'visitor referred through campaign successfully signs up' do
    visit "/?utm_source=abc&utm_campaign=lootcrate&medium=test"
    login_page.visit_join_page
    login_page.click_one_month
    login_page.register @visitor
    subscription_page.fill_in_account_info
    subscription_page.fill_in_shipping_info
    subscription_page.fill_in_credit_card
    VCR.use_cassette 'subscription/chargify/create_1_month_success', match_requests_on: [:method, :uri_ignoring_id] do
      subscription_page.click_subscribe
      expect(page).to have_content("Thank you for subscribing!")
    end
  end

  private

  def create_default_plans
    @plan = FactoryGirl.create(:plan)
    @plan_3_month = FactoryGirl.create(:plan_3_months)
    @plan_6_month = FactoryGirl.create(:plan_6_months)
  end

  def login_page
    @login_page = @login_page || LoginPageObject.new
  end

  def subscription_page
    @subscription_page = @subscription_page || NewSubscriptionPageObject.new(user: @visitor)
  end

end