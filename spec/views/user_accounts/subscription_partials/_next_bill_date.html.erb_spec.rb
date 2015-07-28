require 'spec_helper'

describe "rendering _next_bill_date partial" do
  let(:subscription) { stub_model(Subscription, subscription_status: 'active') }
  let(:next_bill_date) { DateTime.now.strftime("%B %d, %Y") }
  let(:next_bill_date_partial_path) { 'user_accounts/subscription_partials/next_bill_date' }

  context "when subscription is active" do
    before do
      render partial: next_bill_date_partial_path, locals: {subscription: subscription, next_bill_date: next_bill_date}
    end

    it "displays next_bill_date" do
      expect(rendered).to match(next_bill_date)
    end

    context "and is set to cancel at end of period" do
      before do
        subscription.cancel_at_end_of_period = true

        render partial: next_bill_date_partial_path, locals: {subscription: subscription, next_bill_date: next_bill_date}
      end

      it "displays pending cancellation" do
        expect(rendered).to match("Pending Cancellation on #{next_bill_date}")
      end
    end
  end

  context "when subscription is canceled" do
    before do
      subscription.subscription_status = 'canceled'
      render partial: next_bill_date_partial_path, locals: {subscription: subscription, next_bill_date: next_bill_date}
    end

    it "does not display next_bill_date" do
      expect(rendered).to_not match(next_bill_date)
    end
  end
end
