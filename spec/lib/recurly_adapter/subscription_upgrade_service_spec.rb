require 'spec_helper'

RSpec.describe RecurlyAdapter::SubscriptionUpgradeService do
  let(:upgrade_data) { double('upgrade_data') }
  let(:upgrader) do
    RecurlyAdapter::SubscriptionUpgradeService.new(upgrade_data)
  end
  let(:recurly_sub) { double('sub') }
  
  describe "#upgrade" do
    it "executes the upgrade process in correct order" do
      expect(upgrader).to receive(:charge_user_account_for_upgrade).ordered
      expect(upgrader).to receive(:upgrade_subscription_in_recurly).ordered

      upgrader.upgrade
    end

    it "halts execution when failed to charge a user" do
      allow(upgrader).to receive(:charge_user_account_for_upgrade).and_raise('Upgrade Charge Failure')

      expect(upgrader).to_not receive(:upgrade_subscription_in_recurly)
    end
  end

  describe "#preview" do
    it "returns a hash with upgrade information" do
      upgrade_preview = spy
      calculator      = spy
      allow(upgrader).to receive_messages(calculator: calculator, upgrade_preview: upgrade_preview)

      expect(upgrader.preview.keys).to contain_exactly(:charge_in_cents, :prorated_amount_in_cents, :payment_due_in_cents)
    end
  end

  describe "#charge_user_account_for_upgrade" do
    it "charges an account immediately for the upgrade" do
      adjustments        = double('adjustments', create!: true)
      adjustments_params = {
        currency: 'USD',
        tax_exempt: true,
        unit_amount_in_cents: 1000,
        description: 'Charge for upgrades'
      }
      recurly_account    = double('account',
        adjustments: adjustments,
        invoice!: true
      )
      calculator         = instance_double(RecurlyAdapter::SubscriptionUpgradeCalculator)
      allow(upgrader).to receive(:recurly_account).and_return(recurly_account)
      allow(upgrader).to receive(:calculator) { calculator }
      allow(calculator).to receive(:upgrade_charge_amount_in_cents).and_return(1000)

      upgrader.send(:charge_user_account_for_upgrade)

      expect(adjustments).to have_received(:create!).with(adjustments_params)
      expect(recurly_account).to have_received(:invoice!)
    end

    context "when it fails to create an adjustment" do
      it "does not invoice the account" do
        recurly_account = double('recurly_account', invoice!: false)
        calculator      = double('calculator', upgrade_charge_amount_in_cents: 0)
        allow(upgrader).to receive(:recurly_account).and_return(recurly_account)
        allow(upgrader).to receive(:calculator).and_return(calculator)
        allow(recurly_account).to receive_message_chain(:adjustments, :create!).and_raise('422 error')

        expect{
          upgrader.send(:charge_user_account_for_upgrade)
        }.to raise_error(/upgrade charge failure/i)

        expect(recurly_account).to_not have_received(:invoice!)
      end
    end

    context "when it fails to invoice an account" do
      let(:adjustment) { double('adjustment', uuid: 1) }
      let(:recurly_account) { double('recurly_account') }
      let(:calculator) { double('calculator', upgrade_charge_amount_in_cents: 0) }

      before do
        allow(upgrader).to receive(:recurly_account).and_return(recurly_account)
        allow(upgrader).to receive(:calculator).and_return(calculator)
        allow(recurly_account).to receive_message_chain(:adjustments, :create!).and_return(adjustment)
        allow(recurly_account).to receive(:invoice!).and_raise('422 error')
      end

      it "deletes the created adjustment and raises an error" do
        expect(RecurlyWorkers::RemoveAdjustment).to receive(:perform_async).with(adjustment.uuid)

        expect{
          upgrader.send(:charge_user_account_for_upgrade)
        }.to raise_error
      end
    end
  end
end