require 'spec_helper'

# Skips a crate for current month.
describe Subscription::Skipper do
  let(:subscription) do
    create(:subscription, 
      subscription_periods: [build(:active_subscription_period)]
    )
  end
  let(:skipper) { Subscription::Skipper.new(subscription) }

  after { Timecop.return }

  describe "#skip_a_month" do
    context "when it is successful" do
      let(:skipped_to) { DateTime.now + 1.month }
      let(:service) do
        instance_double('service',
          skip_a_month: true,
          skipped_to: skipped_to
        )
      end

      before do
        allow(RecurlyAdapter::SubscriptionSkippingService).to receive(:new).with(subscription.recurly_subscription_id) { service }
      end

      it "updates subscription's next_assessment_at to skipped_to date" do

        skipper.skip_a_month
        subscription.reload

        expect(subscription.next_assessment_at).to eq skipped_to
      end

      it "creates a new subscription skipped month" do
        expect{
          skipper.skip_a_month
        }.to change{subscription.subscription_skipped_months.size}.by(1)
      end

      it 'sends a confirmation email' do
        expect{
          skipper.skip_a_month
        }.to change{SubscriptionWorkers::SkipEmail.jobs.size}.by(1)
      end
    end

    context "when it fails" do
      let(:service) do
        instance_double('service',
          skip_a_month: false
        )
      end

      it "adds a skip_a_month error" do
        allow(RecurlyAdapter::SubscriptionSkippingService).to receive(:new).with(subscription.recurly_subscription_id) { service }

        skipper.skip_a_month

        expect(skipper.errors[:skip_a_month]).to_not be_empty
      end
    end
  end

  describe "#month_to_skip" do
    let(:current_datetime) { DateTime.new(2015, 01, 04) }
    after { Timecop.return }

    context 'when it is before current crate month skip cutoff' do
      it 'returns current crate month year' do
        Timecop.freeze(current_datetime.change(day: 4))

        expect(skipper.month_to_skip).to eq 'JAN2015'
      end
    end

    context 'when it is after current crate month skip cutoff' do
      context 'and its the 6th' do
        it 'returns next month year' do
          Timecop.freeze(current_datetime.change(day: 6))

          expect(skipper.month_to_skip).to eq 'FEB2015'
        end
      end

      context 'and its the 28th' do
        it 'returns next crate month year' do
          Timecop.freeze(current_datetime.change(day: 28))

          expect(skipper.month_to_skip).to eq 'FEB2015'
        end
      end
    end
  end
end