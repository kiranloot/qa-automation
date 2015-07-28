require 'spec_helper'

RSpec.describe Subscription::UpgradeData do
  let(:subscription) { double('subscription') }
  let(:new_plan) { double('new_plan') }
  let(:data) { Subscription::UpgradeData.new(subscription, new_plan) }

  describe "#recurly_subscription_id" do
    it "returns a recurly subscription id" do
      allow(subscription).to receive(:recurly_subscription_id)

      data.recurly_subscription_id

      expect(subscription).to have_received(:recurly_subscription_id)
    end
  end

  describe "#plan_cost_in_cents" do
    it "returns new plan cost in cents" do
      allow(new_plan).to receive(:cost) { 19.95 }
      expected_cost = new_plan.cost * 100
      
      expect(data.plan_cost_in_cents).to eq expected_cost
    end

    it "returns an integer" do
      allow(new_plan).to receive(:cost) { 19.95 }
      
      expect(data.plan_cost_in_cents).to be_an Integer
    end
  end

  describe "#plan_name" do
    it "returns the new plan name" do
      allow(new_plan).to receive(:name) { '3-month-subscription'}
      
      data.plan_name

      expect(new_plan).to have_received(:name)
    end
  end

  describe "#units_remaining" do
    it "returns number of units a user have left" do
      current_period = double('current_period', units_remaining: 3)
      allow(subscription).to receive(:current_period) { current_period }
      
      data.units_remaining

      expect(current_period).to have_received(:units_remaining)
    end
  end

  describe "#next_assessment_at" do
    context "when it is within re-bill adjustment rule" do
      before do
        allow(subscription).to receive(:month_skipped) { false }
        allow(LootcrateConfig).to receive(:within_rebill_adjustment_rule?).and_return(true)
        allow(new_plan).to receive(:period).and_return(3)
        Timecop.freeze(DateTime.new(2015, 10, 15))
      end
      after { Timecop.return }

      it "re-adjust next billing date to the 5th" do
        allow(data).to receive(:adjust_rebill_month_for_unit_created).and_return(0.months)
        expected_date = LootcrateConfig.current_datetime.change(day: 5) + new_plan.period.months

        expect(data.next_assessment_at.to_i).to eq expected_date.to_i
      end

      context "and a unit is created for current_crate_month" do
        it "adjust next billing date by an extra month" do
          unit           = double('subscription_unit')
          current_period = double('current_period')
          allow(Subscription::CurrentUnit).to receive(:find).and_return(unit)
          allow(subscription).to receive(:current_period).and_return(current_period)

          expected_date = LootcrateConfig.current_datetime.change(day: 5) + new_plan.period.months + 1.months

          expect(data.next_assessment_at.to_i).to eq expected_date.to_i
        end
      end
    end

    context "when it is NOT within re-bill adjustment rule" do
      it "doesn't re-adjust re-bill date" do
        Timecop.freeze(DateTime.new(2015, 10, 20))
        allow(subscription).to receive(:month_skipped) { false }
        allow(LootcrateConfig).to receive(:within_rebill_adjustment_rule?).and_return(false)
        allow(new_plan).to receive(:period).and_return(3)

        expected_date = LootcrateConfig.current_datetime + new_plan.period.months

        expect(data.next_assessment_at.to_i).to eq expected_date.to_i

        Timecop.return
      end

      context "and month is skipped" do
        it "re-adjust month by 1" do
          Timecop.freeze(DateTime.new(2015, 10, 20))
          allow(subscription).to receive(:month_skipped) { true }
          allow(LootcrateConfig).to receive(:within_rebill_adjustment_rule?).and_return(false)
          allow(new_plan).to receive(:period).and_return(3)

          expected_date = LootcrateConfig.current_datetime + new_plan.period.months + 1.month

          expect(data.next_assessment_at.to_i).to eq expected_date.to_i

          Timecop.return
        end
      end
    end
  end
end