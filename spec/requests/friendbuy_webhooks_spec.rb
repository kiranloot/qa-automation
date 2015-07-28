require 'spec_helper'

describe 'Friendbuy webhooks' do
  describe 'conversion_succeeded' do
    it 'credits the right referrer' do

      referrer = create(:user)
      # friendbuy_event = double("friendbuy_event", new_conversion: '1')
      # FriendbuyEvent.stubs(new: friendbuy_event)

      post friendbuy_conversion_path, share_customer_id: referrer.id,
        new_order_customer_id: '2', reward_amount: '5.00'

      store_credit = referrer.store_credits.first
      # expect(friendbuy_event).to have_received(:new)

      expect(referrer.store_credits.count).to eq(1)
      expect(store_credit.amount).to eq(5)
      expect(store_credit.status).to eq("pending")
    end

    it 'responds with 200 OK' do
      referrer = create(:user)

      post friendbuy_conversion_path, share_customer_id: referrer.id, reward_amount: '5.00'

      expect(response).to be_success
    end
  end
end