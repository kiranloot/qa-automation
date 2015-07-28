require 'spec_helper'

describe Analytics do
  describe 'track_subscription_purchase' do
    it 'sends purchase information to sailthru' do
      expect_any_instance_of(Sailthru::Client).to receive(:purchase)
      user = build(:user)
      Analytics::Purchase.new(user,
                              plan_name: 'test-plan-name',
                              subscription_id: 1,
                              total: '10',
                              campaign_id: 'message_id').track_subscription_purchase
    end
  end
end
