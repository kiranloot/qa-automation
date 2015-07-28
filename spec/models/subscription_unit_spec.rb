require 'spec_helper'

RSpec.describe SubscriptionUnit do
  describe "#handle_subscription_updated" do
    let(:subscription_period) do
      create(:active_subscription_period,
        subscription: create(:subscription)
      )
    end
    let(:unit) do
      create(:subscription_unit,
        subscription_period: subscription_period
      )
    end
    
    context "when unit is NOT shipped" do
      it "updates netsuite_sku and shirt_size" do
        allow(unit).to receive(:shipped?).and_return(false)
        subscription = unit.subscription

        unit.handle_subscription_updated

        expect(unit.netsuite_sku).to include(subscription.shirt_size)
        expect(unit.shirt_size).to eq subscription.shirt_size
      end
    end

    context "when unit is shipped" do
      it "does not update unit" do
        allow(unit).to receive(:shipped?).and_return(true)

        expect(unit).to_not receive(:update_attributes)

        unit.handle_subscription_updated
      end
    end
  end
end