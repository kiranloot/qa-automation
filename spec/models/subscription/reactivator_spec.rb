require 'spec_helper'

describe Subscription::Reactivator do
  let(:subscription) { create(:subscription, subscription_status: 'canceled') }
  let(:reactivator) { Subscription::Reactivator.new(subscription) }

  describe "#reactivate" do
    context "when it reactivates" do
      let(:service) do
        instance_double(RecurlyAdapter::SubscriptionReactivationService,
          reactivate: true,
          recurly_subscription_id: '1',
          errors: double('errors', presence: nil)
        )
      end
      let(:calculator) do
        instance_double(Subscription::ReactivationCalculator,
                        total_payment: 1000,
                        next_assessment_at: DateTime.now
                       )
      end

      before do
        allow(RecurlyAdapter::SubscriptionReactivationService).to receive(:new) { service }
        allow(Subscription::ReactivationCalculator).to receive(:new) { calculator }
      end

      it "changes subscription's status to active" do
        reactivator.reactivate
        subscription.reload

        expect(subscription.subscription_status).to eq 'active'
      end

      it "changes subscription's cancel_at_end_of_period to nil" do
        subscription.update_attributes(cancel_at_end_of_period: true)
        subscription.save

        reactivator.reactivate
        subscription.reload

        expect(subscription.cancel_at_end_of_period).to eq nil
      end

      it "queues reactivation email" do
        expect{
          reactivator.reactivate
        }.to change(SubscriptionWorkers::ReactivationEmail.jobs, :size).by(1)
      end

      it "queues email list status updater" do
        expect{
          reactivator.reactivate
        }.to change(SubscriptionWorkers::EmailListStatusUpdater.jobs, :size).by(1)
      end

      it "sets the version's event name to 'reactivated'", versioning: true do
        reactivator.reactivate
        subscription.reload

        version = subscription.versions.last

        expect(version.event).to eq 'reactivated'
      end

      it "creates a subscription period" do
        expect_any_instance_of(SubscriptionPeriod::Handler).to receive(:handle_subscription_reactivated)

        reactivator.reactivate
      end

      context "when date is within rebill adjustment rule" do
        it "re-adjust rebill date" do
          Timecop.freeze(DateTime.new(2015, 01, 07))

          expect{
            reactivator.reactivate
          }.to change(RecurlyWorkers::MoveRebillDate.jobs, :size).by(1)

          Timecop.return
        end
      end

      context "when date is NOT within rebill adjustment rule" do
        it "does not readadjust rebill date" do
          Timecop.freeze(DateTime.new(2015, 01, 05))

          expect{
            reactivator.reactivate
          }.to change(RecurlyWorkers::MoveRebillDate.jobs, :size).by(0)

          Timecop.return
        end
      end
    end

    context "when it fails to reactivate" do
      let(:error_msg) { 'RecurlyAdapter::SubscriptionReactivationService' }
      before do
        service = RecurlyAdapter::SubscriptionReactivationService.new({ })
        errors = ActiveModel::Errors.new service
        errors.add :key, error_msg
        allow(service).to receive_message_chain(:errors, :presence) { errors }
        allow(service).to receive(:reactivate) { true }
        allow(service).to receive(:recurly_subscription_id) { '1' }
        allow(RecurlyAdapter::SubscriptionReactivationService).to receive(:new) { service }

        reactivator.reactivate
      end

      it "doesn't change subscription's status to active" do
        expect(subscription.reload.subscription_status).to_not eq 'active'
      end

      describe 'accumulates errors' do
        it { expect(reactivator.errors.any?).to be_truthy }
        it { expect(reactivator.errors).to include(:key) }
        it { expect(reactivator.errors[:key]).to include(error_msg) }
      end
    end
  end
end
