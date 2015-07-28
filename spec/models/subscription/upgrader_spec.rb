require 'spec_helper'

RSpec.describe Subscription::Upgrader do
  let(:current_plan) { create(:plan) }
  let(:desired_plan) { create(:plan_6_months) }
  let(:subscription) { create(:subscription, plan: current_plan) }
  let(:subscription) do
    create(:subscription,
      plan: current_plan,
      subscription_periods: [build(:active_subscription_period)]
    )
  end
  let(:upgrader) { Subscription::Upgrader.new(subscription, desired_plan) }
  
  describe "#upgrade" do
    before do
      allow_any_instance_of(RecurlyAdapter::SubscriptionUpgradeService).to receive(:upgrade) { true }
    end

    context "when it upgrades successfully" do
      before do
        allow_any_instance_of(RecurlyAdapter::SubscriptionUpgradeService).to receive_message_chain(:errors, :presence) { false }
      end

      it "changes subscription's plan to desired_plan" do
        expect{
          upgrader.upgrade
          subscription.reload
        }.to change{subscription.plan}.from(current_plan).to(desired_plan)
      end

      it "updates the next_assessment_at" do
        expect{
          upgrader.upgrade
          subscription.reload
        }.to change{subscription.next_assessment_at}
      end

      it "sets the lastest version's event name to 'upgraded'", versioning: true do
        upgrader.upgrade
        subscription.reload

        version = subscription.versions.last

        expect(version.event).to eq 'upgraded'
      end

      it "handles subscription period" do
        expect_any_instance_of(SubscriptionPeriod::Handler).to receive(:handle_subscription_upgraded)

        upgrader.upgrade
      end

      it "sends upgrade confirmation email" do
        expect{
          upgrader.upgrade
        }.to change(SubscriptionWorkers::UpgradeEmail.jobs, :size).by(1)
      end
    end

    context "when it fails to upgrade" do
      it "adds an upgrade error" do
        error = double('error', full_messages: 'Error')
        allow_any_instance_of(RecurlyAdapter::SubscriptionUpgradeService).to receive_message_chain(:errors, :presence) { error }

        upgrader.upgrade
        
        expect(upgrader.errors[:upgrade]).to_not be_empty
      end
    end
  end
end