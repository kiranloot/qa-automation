require 'spec_helper'

RSpec.describe Subscription::OrderHandler do
  let(:handler) { Subscription::OrderHandler.new('APR2015') }
  let(:current_period) do
    create(:active_subscription_period,
      subscription: create(:subscription)
    )
  end

  describe "#twentieth_of_crate_month" do
    it "returns the twentieth of month_year" do
      expected_date = Date.new(2015, 04, 20)

      expect(handler.twentieth_of_crate_month).to eq expected_date
    end
  end

  describe "#handle_all_orders" do
    context "when there are active subscriptions" do
      it "creates subscription unit(s)" do
        current_period
        allow(handler).to receive(:push_to_wombat)

        expect{
          handler.handle_all_orders
        }.to change(SubscriptionUnit, :count).by(1)
      end

      it "pushes to wombat" do
        create(:active_subscription, subscription_periods: [current_period])
        allow(handler).to receive(:push_to_wombat)

        expect(handler).to receive(:push_to_wombat).at_least(:once)

        handler.handle_all_orders
      end
    end

    context "when there are NO active subscriptions" do
      it "does not handles the orders" do
        create(:canceled_subscription)

        expect(handler).to_not receive(:handle_orders)

        handler.handle_all_orders
      end
    end
  end

  describe "#handle_orders(subscriptions)" do
    it "only create units for subscriptions that have paid for current crate month" do
      allow(handler).to receive(:push_to_wombat)
      current_time = DateTime.new(2015, 04, 10)
      Timecop.freeze(current_time)

      paid_subscription       = create(:subscription, next_assessment_at: current_time.change(day: 21), subscription_periods: [current_period])
      nonpaid_subscription    = create(:subscription, next_assessment_at: current_time)

      expect{
        handler.send(:handle_orders, [nonpaid_subscription, paid_subscription])
      }.to change(SubscriptionUnit, :count).by(1)

      Timecop.return
    end

    it "creates a unit when one does not exist within a subscription period" do
      sub = create(:active_subscription, subscription_periods: [current_period])
      allow(handler).to receive(:push_to_wombat)

      expect{
        handler.send(:handle_orders, [sub])
        current_period.reload
      }.to change{current_period.subscription_units.count}.by(1)
    end

    it "create unit(s) with a status of 'awaiting_shipment'" do
      sub = create(:active_subscription, subscription_periods: [current_period])
      allow(handler).to receive(:push_to_wombat)

      handler.send(:handle_orders, [sub])
      current_period.reload
      su = current_period.subscription_units.first

      expect(su.status).to eq 'awaiting_shipment'
    end

    it "does not create a unit when subscription is skipped for current_crate month" do
      sub = create(:active_subscription,
        subscription_periods: [current_period]
      )
      create(:subscription_skipped_month,
        month_year: Subscription::CrateDateCalculator.current_crate_month_year,
        subscription: sub
      )

      expect{
        handler.send(:handle_orders, [sub])
        current_period.reload
      }.to_not change{current_period.subscription_units.count}

      allow(handler).to receive(:push_to_wombat)
    end
  end
end
