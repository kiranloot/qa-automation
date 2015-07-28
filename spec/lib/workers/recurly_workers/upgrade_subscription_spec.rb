require 'spec_helper'

RSpec.describe RecurlyWorkers::UpgradeSubscription do
  describe '#perform' do
    it 'upgrades subscription in recurly using correct flow' do
      worker      = RecurlyWorkers::UpgradeSubscription.new
      recurly_sub = double('recurly_sub', postpone: true, update_attributes!: true)
      allow(Recurly::Subscription).to receive(:find) { recurly_sub }

      worker.perform('1', '1-month-subscription', DateTime.now)

      expect(recurly_sub).to have_received(:update_attributes!).ordered
      expect(recurly_sub).to have_received(:postpone).ordered
    end

    it "updates recurly's subscription to a new plan on renewal" do
      worker        = RecurlyWorkers::UpgradeSubscription.new
      recurly_sub   = double('recurly_sub', postpone: true, update_attributes!: true)
      plan_name     = '3-month-subscription'
      update_params = {timeframe: 'renewal', plan_code: plan_name}
      allow(Recurly::Subscription).to receive(:find) { recurly_sub }   

      worker.perform('1', plan_name, DateTime.now)    

      expect(recurly_sub).to have_received(:update_attributes!).with(update_params)
    end

    context "when it fails to postpone" do
      it "reverts recurly subscription plan to original" do
        worker        = RecurlyWorkers::UpgradeSubscription.new
        recurly_sub   = double('recurly_sub', update_attributes!: true, plan_code: '1-month-subscription')
        allow(Recurly::Subscription).to receive(:find) { recurly_sub }   
        allow(recurly_sub).to receive(:postpone).and_raise

        worker.perform('1', '3-month-subscription', DateTime.now)    

        expect(recurly_sub).to have_received(:update_attributes!).with({timeframe: 'renewal', plan_code: recurly_sub.plan_code})
      end
    end
  end
end
