require 'spec_helper'
include SubscriptionHelper

describe 'rendering user_accounts/_shipments_tracking.html.erb' do
  
  let!(:subscription) { create(:subscription, subscription_periods: [build(:active_subscription_period)]) }

  let!(:subscription_unit) { create(:subscription_unit, subscription_period: subscription.subscription_periods.first) }

  let!(:shipments_tracking_partial_path) { 'user_accounts/shipments_tracking' }

  context 'when there is a displayable_shipment' do
    before do
      render partial: shipments_tracking_partial_path, locals: { subscription: subscription }
    end

    it 'should display displayable_shipment.month_year' do
      displayable_shipment = display_current_monthly_crate(subscription)
      expect(rendered).to match(displayable_shipment.month_year)
    end

    it 'should display displayable_shipment.tracking_number as link' do
      displayable_shipment = display_current_monthly_crate(subscription)
      expect(rendered).to have_link(displayable_shipment.tracking_number)
    end

    it 'should have displayable_shipment.tracking_url' do
      displayable_shipment = display_current_monthly_crate(subscription)
      expect(rendered).to match(/#{Regexp.quote(displayable_shipment.tracking_url)}/)
    end
  end
end