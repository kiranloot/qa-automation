require 'spec_helper'

describe Subscription::ReactivationData do
  let(:subscription) { instance_double(Subscription) }
  let(:coupon) { instance_double(Coupon) }
  let(:data) { Subscription::ReactivationData.new(subscription, coupon) }
  
  describe "#current_plan_name" do
    it "returns the subscription's current plan_name" do
      allow(subscription).to receive(:plan_name)

      data.current_plan_name
      
      expect(subscription).to have_received(:plan_name)
    end
  end

  describe "#recurly_account_id" do
    it "returns the subscription's recurly_account_id" do
      allow(subscription).to receive(:recurly_account_id)

      data.recurly_account_id

      expect(subscription).to have_received(:recurly_account_id)
    end
  end
end