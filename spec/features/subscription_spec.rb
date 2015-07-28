require 'spec_helper'

feature 'Subscriptions' do
  given(:subscription) do 
    create(:subscription, 
      subscription_periods: [build(:active_subscription_period)],
      recurly_subscription_id: "2eb83fa4e80225d69b5a5f4950b2775f"
    ) 
  end
  given(:user) { create(:user, subscriptions: [subscription]) }
  given(:account_page) { UserAccountPageObject.new }
  given(:subscription_page) { SubscriptionPageObject.new }
  given(:login_page) { LoginPageObject.new }

  context 'cancel_at_end_of_period' do
    background do
      login_as user, scope: :user
      allow_any_instance_of(User).to receive(:sync_subscriptions!).and_return(nil)
    end

    scenario "cancelling a subscription at end of period" do
      account_page.visit_page
      account_page.view_subscriptions
      account_page.cancel_a_subscription subscription.id
      subscription.reload

      expect(subscription.cancel_at_end_of_period).to eq(true)
    end
  end

  context "reactivate" do
    background do
      login_as user, scope: :user
      subscription.update_attributes(subscription_status: 'canceled')
      allow_any_instance_of(User).to receive(:sync_subscriptions!).and_return(nil)
    end

    scenario "reactivating a canceled subscription" do
      account_page.visit_page
      account_page.view_subscriptions
      account_page.reactivate_a_subscription subscription.id
      subscription.reload

      expect(subscription.subscription_status).to eq 'active'
      expect(subscription.cancel_at_end_of_period).to eq nil
    end
  end

  context "upgrade" do
    background do
      @plan = FactoryGirl.create(:plan_12_months)
      login_as user, scope: :user
      allow_any_instance_of(User).to receive(:sync_subscriptions!).and_return(nil)
    end

    scenario "upgrading a subscription" do
      subscription_page.visit_page
      subscription_page.click_upgrade
      subscription_page.click_upgrade_submit
      expect(current_path).to eq(user_accounts_subscriptions_path)
      expect(page).to have_content(@plan.name)
      subscription.reload
      expect(subscription.subscription_periods[-1].term_length).to eq(@plan.period)
    end


  end

end
