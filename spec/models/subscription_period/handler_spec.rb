require 'spec_helper'

RSpec.describe SubscriptionPeriod::Handler do
  let(:subscription) { create(:subscription) }
  let(:current_period) do
    create(:active_subscription_period,
      subscription: subscription
    )
  end

  describe "#handle_subscription_created" do
    let!(:handler) { SubscriptionPeriod::Handler.new(subscription) }

    it "creates a new subscription period" do
      expect{
        handler.handle_subscription_created
      }.to change(SubscriptionPeriod, :count).by(1)
    end

    it "uses the plan period as the term_length" do
      handler.handle_subscription_created

      period = subscription.subscription_periods.last

      expect(period.term_length).to eq subscription.plan.period
    end

    it "uses the time of creation as the start_date" do
      current_date = Date.today
      Timecop.freeze(current_date)

      handler.handle_subscription_created

      period = subscription.subscription_periods.last
      expect(period.start_date.to_date).to eq current_date

      Timecop.return
    end

    it "uses the next_assessment_at date as the expected_end_date" do
      Timecop.freeze(subscription.next_assessment_at.to_date)

      handler.handle_subscription_created
      period = subscription.subscription_periods.last

      expect(period.expected_end_date.to_date).to eq subscription.next_assessment_at.to_date

      Timecop.return
    end
  end

  describe "#handle_subscription_renewed" do
    let(:handler) { SubscriptionPeriod::Handler.new(subscription) }

    before do
      subscription.subscription_periods << current_period
      subscription.save
    end

    it "creates a new subscription period" do
      expect{
        handler.handle_subscription_renewed
      }.to change(SubscriptionPeriod, :count).by(1)
    end

    it "sets creation_reason to subscription_renewed" do
      handler.handle_subscription_renewed

      period = subscription.subscription_periods.last

      expect(period.creation_reason).to eq 'subscription_renewed'
    end

    it "sets status to active" do
      period = handler.handle_subscription_renewed

      expect(period.status).to eq 'active'
    end

    it "uses the time of creation as the start_date" do
      current_date = Date.today
      Timecop.freeze(current_date)

      handler.handle_subscription_renewed
      period = subscription.subscription_periods.last

      expect(period.start_date.to_date).to eq current_date

      Timecop.return
    end

    it "uses the next_assessment_at date as the expected_end_date" do
      Timecop.freeze(subscription.next_assessment_at.to_date)

      handler.handle_subscription_renewed
      period = subscription.subscription_periods.last

      expect(period.expected_end_date.to_date).to eq subscription.next_assessment_at.to_date

      Timecop.return
    end

    it "changes old period's status to 'renewed'" do
      handler.handle_subscription_renewed
      current_period.reload

      expect(current_period.status).to eq 'renewed'
    end

    it "changes old period's actual_end_date to expected_end_date" do
      handler.handle_subscription_renewed
      current_period.reload

      expect(current_period.actual_end_date).to eq current_period.expected_end_date
    end

    it "doesn't create multiple periods within the hour" do
      expect{
        Timecop.freeze(1.hour.ago)
        handler.handle_subscription_renewed
        Timecop.return

        Timecop.freeze(1.minute.ago)
        handler.handle_subscription_renewed
      }.to change{subscription.subscription_periods.count}.by(1)

      Timecop.return
    end
  end

  describe "#handle_subscription_reactivated" do
    let!(:handler) { SubscriptionPeriod::Handler.new(subscription) }

    it "creates a new subscription period" do
      expect{
        handler.handle_subscription_reactivated
      }.to change(SubscriptionPeriod, :count).by(1)
    end

    it "sets creation_reason to subscription_reactivated" do
      handler.handle_subscription_reactivated

      period = subscription.subscription_periods.last

      expect(period.creation_reason).to eq 'subscription_reactivated'
    end
  end

  describe "#handle_subscription_upgraded" do
    let!(:handler) { SubscriptionPeriod::Handler.new(subscription) }

    before do
      allow(handler).to receive(:current_period).and_return(current_period)
    end

    it "creates a new subscription period" do
      expect{
        handler.handle_subscription_upgraded
      }.to change(SubscriptionPeriod, :count).by(1)
    end

    it "sets creation_reason to subscription_upgraded" do
      handler.handle_subscription_upgraded

      period = subscription.subscription_periods.last

      expect(period.creation_reason).to eq 'subscription_upgraded'
    end

    it "changes old period's status to 'upgraded'" do
      handler.handle_subscription_upgraded
      current_period.reload

      expect(current_period.status).to eq 'upgraded'
    end

    it "changes old period's actual_end_date to current_date" do
      current_date = Date.today
      Timecop.freeze(current_date)

      handler.handle_subscription_upgraded
      current_period.reload

      expect(current_period.actual_end_date.to_date).to eq current_date
    end
  end

  describe "#handle_subscription_canceled" do
    let(:handler) { SubscriptionPeriod::Handler.new(subscription) }

    before do
      allow(handler).to receive(:current_period).and_return(current_period)
    end

    it "changes current_period's status to 'canceled'" do
      handler.handle_subscription_canceled

      current_period.reload

      expect(current_period.status).to eq 'canceled'
    end

    it "changes current_period's actual_end_date to current_date" do
      current_date = Date.today
      Timecop.freeze(current_date)

      handler.handle_subscription_canceled
      current_period.reload

      expect(current_period.actual_end_date.to_date).to eq current_date

      Timecop.return
    end
  end

  describe "#handle_subscription_skipped" do
    let(:handler) { SubscriptionPeriod::Handler.new(subscription) }

    before do
      allow(handler).to receive(:current_period).and_return(current_period)
    end

    it "changes the expected_end_date" do
      expect{
        handler.handle_subscription_skipped
      }.to change{current_period.expected_end_date}
    end
  end
end