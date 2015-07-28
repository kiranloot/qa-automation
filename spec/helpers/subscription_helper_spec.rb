require 'spec_helper'

describe SubscriptionHelper do
  describe '#skip_a_month_link(subscription)' do
    context 'subscription is skipped' do
      it 'shows month that is skipped' do
        sub = instance_double(Subscription, month_skipped: 'JAN2015')
        expected_message = "You are set to skip #{sub.month_skipped}"

        expect(helper.skip_a_month_link(sub)).to eq expected_message
      end
    end

    context 'subscription is not skipped' do
      it 'shows month to skip' do
        sub = instance_double(Subscription, month_skipped: nil)
        skipper = Subscription::Skipper.new(sub)
        expected_message = "Skip #{skipper.month_to_skip}"

        expect(helper.skip_a_month_link(sub)).to eq expected_message
      end
    end
  end

  describe "#subscription_status(subscription" do
    context "when subscription is active" do
      let(:subscription) { create(:subscription, subscription_status: 'active') }

      it "shows 'Active'" do
        expect(helper.subscription_status(subscription)).to eq 'Active'
      end

      context "and it is pending cancellation" do
        it "shows 'Pending Cancellation'" do
          allow(subscription).to receive(:cancel_at_end_of_period).and_return(true)
          expected_message = 'Pending Cancellation'

          expect(helper.subscription_status(subscription)).to eq expected_message
        end
      end
    end

    context "when subscription is canceled" do
      let(:subscription) { create(:subscription, subscription_status: 'canceled') }

      it "shows 'Canceled'" do
        expect(helper.subscription_status(subscription)).to eq 'Canceled'
      end

      context "and it was pending cancellation" do
        it "shows 'Canceled'" do
          allow(subscription).to receive(:cancel_at_end_of_period).and_return(true)
          expected_message = 'Canceled'

          expect(helper.subscription_status(subscription)).to eq expected_message
        end
      end
    end
  end

  describe "#current_unit_editable?(current_period)" do
    it "returns true when current unit is NOT shipped" do
      current_period = double
      current_unit   = double('current_unit', shipped?: false)
      allow(Subscription::CurrentUnit).to receive(:find).and_return(current_unit)

      expect(helper.current_unit_editable?(current_period)).to eq true
    end

    it "returns false when current unit is shipped" do
      current_period = double
      current_unit   = double('current_unit', shipped?: true)
      allow(Subscription::CurrentUnit).to receive(:find).and_return(current_unit)

      expect(helper.current_unit_editable?(current_period)).to eq false
    end
  end
end

def parse_month_year month_year
  Date.parse(month_year).strftime("%B %Y")
end