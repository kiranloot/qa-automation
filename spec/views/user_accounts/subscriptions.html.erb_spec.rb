require 'spec_helper'

describe "rendering user_accounts/subscription.html.erb" do

  let(:user) { create(:user) }
  let!(:subscription) { build_stubbed(:subscription, subscription_periods: [build_stubbed(:active_subscription_period)]) }
  let(:subscription_units) { [build_stubbed(:subscription_unit, subscription_period: subscription.subscription_periods.first)] }
  let(:plan_12) { build_stubbed(:plan_12_months)}
  let(:subscription_12_months) { build_stubbed(:subscription, plan: plan_12, subscription_periods: [build_stubbed(:active_subscription_period)]) }
  let(:subscription_pending_cancel) { build_stubbed(:subscription, cancel_at_end_of_period: true, subscription_periods: [build_stubbed(:active_subscription_period)]) }
  let(:subscription_canceled) { build_stubbed(:subscription, subscription_status: 'canceled', subscription_periods: [build_stubbed(:active_subscription_period)]) }
  let(:user_accounts_subscription_path) { 'user_accounts/subscriptions' }
  let(:stub_shipments_tracking) { stub_template '_shipments_tracking.html.erb' => '' }
  let(:stub_looter_info) { stub_template '_looter_info.html.erb' => '' }
  let(:stub_payment_method) { stub_template '_payment_method.html.erb' => "Cancel Subscription | XXXX-XXXX-XXXX-1111 | /subscriptions/#{subscription.id}/cancellation" }
  let(:stub_billing_address) { stub_template '_billing_address.html.erb' => '' }
  let(:stub_shipping_address) { stub_template '_shipping_address.html.erb' => '' }
  let(:stub_promotion) { stub_template '_promotion.html.erb' => '' }
  let(:upgradable_subscriptions) { [subscription_12_months] }

  before(:each) do
    stub_shipments_tracking
    stub_looter_info
    stub_payment_method
    stub_billing_address
    stub_shipping_address
    stub_promotion
  end

  context 'when subscription is active and less than 12 months' do
    before do
      sign_in :user, user
      assign(:subscriptions, [subscription])
      assign(:upgradable_subscriptions, [subscription_12_months])
      render template: user_accounts_subscriptions_path
    end

    it 'displays subscription.plan_name' do
      expect(rendered).to match(subscription.plan_name)
    end

    it 'displays Upgrade link' do
      expect(rendered).to match('Upgrade')
    end

    it 'displays correct upgrade URL' do
      expect(rendered).to match(/\/subscriptions\/#{subscription.id}\/upgrade\/preview/)
    end

    it 'displays subscription.next_billing_date' do
      expect(rendered).to match(subscription.next_billing_date)
    end

    it 'displays Status Active' do
      expect(rendered).to match('Active')
    end

    it 'renders _shipments_tracking partial' do
      expect(view).to render_template(partial: "_shipments_tracking", locals: {subscription: subscription})
    end

    it 'renders _looter_info partial' do
      expect(view).to render_template(partial: "_looter_info", locals: {subscription: subscription})
    end

    it 'renders _payment_method partial' do
      expect(view).to render_template(partial: "_payment_method", locals: {subscription: subscription, billing_address: subscription.billing_address})
    end

    it 'renders _billing_address partial' do
      expect(view).to render_template(partial: "_billing_address", locals: {subscription: subscription, billing_address: subscription.billing_address})
    end

    it 'renders _shipping_address partial' do
      expect(view).to render_template(partial: "_shipping_address", locals: {shipping_address: subscription.shipping_address})
    end

    it 'renders _promotion partial' do
      expect(view).to render_template(partial: "_promotion", locals: {upgradable_subscriptions: upgradable_subscriptions})
    end

    it 'displays subscription.shirt_size' do
      expect(rendered).to match(subscription.shirt_size)
    end

    it "displays the correct edit shirt size URL" do
      expect(rendered).to match(/\/subscriptions\/#{subscription.id}/)
    end

    it 'displays subscription.masked_card_number' do
      expect(rendered).to match(subscription.masked_card_number)
    end

    it "displays the correct edit billing address URL" do
      expect(rendered).to match(/\/billing_addresses\/#{subscription.billing_address.id}/)
    end

    it "displays subscription.billing_address.line_1" do
      expect(rendered).to match(subscription.billing_address.line_1)
    end

    it "displays subscription.billing_address.city" do
      expect(rendered).to match(subscription.billing_address.city)
    end

    it "displays subscription.billing_address.state" do
      expect(rendered).to match(subscription.billing_address.state)
    end

    it "displays subscription.billing_address.zip" do
      expect(rendered).to match(subscription.billing_address.zip)
    end

    it "displays subscription.shipping_address.first_name" do
      expect(rendered).to match(subscription.shipping_address.first_name)
    end

    it "displays the correct edit shipping address URL" do
      expect(rendered).to match(/\/shipping_addresses\/#{subscription.shipping_address.id}/)
    end

    it "displays subscription.shipping_address.last_name" do
      expect(rendered).to match(subscription.shipping_address.last_name)
    end

    it "displays subscription.shipping_address.line_1" do
      expect(rendered).to match(subscription.shipping_address.line_1)
    end

    it "displays subscription.shipping_address.city" do
      expect(rendered).to match(subscription.shipping_address.city)
    end

    it "displays subscription.shipping_address.state" do
      expect(rendered).to match(subscription.shipping_address.state)
    end

    it "displays subscription.shipping_address.zip" do
      expect(rendered).to match(subscription.shipping_address.zip)
    end

    it "displays Cancel subscription" do
      expect(rendered).to match('Cancel Subscription')
    end

    it "displays correct cancel subscription URL" do
      expect(rendered).to match(/\/subscriptions\/#{subscription.id}\/cancellation/)
    end

  end

  context 'when subscription is active and equals 12 months' do
    before do
      sign_in :user, user
      assign(:subscriptions, [subscription_12_months])
      render template: user_accounts_subscriptions_path
    end

    it 'does not display upgrade' do
      expect(rendered).not_to match('Upgrade')
    end
  end

  context 'when subscription is active and pending cancellation' do
    before do
      sign_in :user, user
      assign(:subscriptions, [subscription_pending_cancel])
      render template: user_accounts_subscriptions_path
    end

    it 'displays Remove Cancellation' do
      expect(rendered).to match('Remove Cancellation')
    end

    it 'displays correct remove cancellation URL' do
      expect(rendered).to match(/\/subscriptions\/#{subscription_pending_cancel.id}\/undo_cancellation_at_end_of_period/)
    end
  end

  context 'when subscription is not active' do
    before do
      sign_in :user, user
      assign(:subscriptions, [subscription_canceled])
      render template: user_accounts_subscriptions_path
    end

    it 'displays Reactivate link' do
      expect(rendered).to match('Reactivate')
    end

    it 'displays correct reactivate URL' do
      expect(rendered).to match(/\/subscriptions\/#{subscription_canceled.id}\/reactivation/)
    end
  end

  context 'when there are no subscriptions' do
    before do
      sign_in :user, user
      assign(:subscriptions, [])
      render template: user_accounts_subscriptions_path
    end

    it 'displays NO ACTIVE SUBSCRIPTIONS!' do
      expect(rendered).to match('NO ACTIVE SUBSCRIPTIONS!')
    end
  end

end

