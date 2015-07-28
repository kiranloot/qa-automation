require 'spec_helper'

describe Subscription::MembershipCardCalculator do
  after do
    Timecop.return
  end

  let(:subscription) { create(:subscription, subscription_status: 'active') }

  before do
    Timecop.freeze(2015, 2, 19)
    subscription.last_payment_date = 1.day.ago
  end

  context "new subscription" do
    it "doesn't offer a membership card" do
      subscription.creation_date = 1.day.ago
      expect(Subscription::MembershipCardCalculator.third_subscription_crate_in_lifetime?(subscription)).to be_falsey
    end
  end

  context "really old subscription" do
    it "doesn't offer a membership card" do
      subscription.creation_date = 1.year.ago
      expect(Subscription::MembershipCardCalculator.third_subscription_crate_in_lifetime?(subscription)).to be_falsey
    end
  end

  context "canceled subscription" do
    it "doesn't offer a membership card" do
      subscription.subscription_status = 'canceled'
      subscription.creation_date = 3.months.ago + 2.days
      expect(Subscription::MembershipCardCalculator.third_subscription_crate_in_lifetime?(subscription)).to be_falsey
    end
  end

  context "in 2nd-month subscription" do
    it "doesn't offer a membership card" do
      subscription.creation_date = 2.months.ago + 2.days
      expect(Subscription::MembershipCardCalculator.third_subscription_crate_in_lifetime?(subscription)).to be_falsey
    end
  end

  context "in 3rd-month subscription" do
    it "offers a membership card" do
      subscription.creation_date = 3.months.ago + 2.days
      expect(Subscription::MembershipCardCalculator.third_subscription_crate_in_lifetime?(subscription)).to be_truthy
    end
  end

  context "in 4th-month subscription" do
    it "doesn't offer a membership card" do
      subscription.creation_date = 4.months.ago + 2.days
      expect(Subscription::MembershipCardCalculator.third_subscription_crate_in_lifetime?(subscription)).to be_falsey
    end
  end
end
