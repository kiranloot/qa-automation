require 'spec_helper'

describe FriendbuyEvent do

  describe '#new_conversion' do
    it 'records conversion' do
      user = create(:user)
      expect{FriendbuyEvent.new(share_customer_id: user.id,
        new_order_customer_id: '2', reward_amount: '5.00').new_conversion}.to change{ FriendbuyConversionEvent.count }.by(1)
    end

    it 'gives referred user store credit' do
      user = create(:user)
      expect{FriendbuyEvent.new(share_customer_id: user.id,
        new_order_customer_id: '2', reward_amount: '5.00').new_conversion}.to change{ user.store_credits.count }.by(1)
      expect(user.store_credits.first.status).to eq('pending')
    end

    it 'gives $5 pending credit' do
      user = create(:user)
      FriendbuyEvent.new(share_customer_id: user.id,
        new_order_customer_id: '2', reward_amount: '7.00'
      ).new_conversion

      store_credit = user.store_credits.first
      expect(store_credit.status).to eq('pending')
      expect(store_credit.amount).to eq(7.00)
    end

    context 'self referral' do
      it 'sets status to possible_self_referral' do
        user = create(:user)
        FriendbuyEvent.new(
          share_customer_id: user.id,
          new_order_customer_id: '2',
          possible_self_referral: 'True',
          reward_amount: '5.00'
        ).new_conversion
        store_credit = user.store_credits.first
        expect(store_credit.status).to eq('possible_self_referral')
      end
    end

  end

  context "only referrer's email being passed in" do
    subject do FriendbuyEvent.new(
        email: 'testcase@lootcrate.com',
        new_order_customer_id: '2',
        possible_self_referral: 'True',
        reward_amount: '5.00'
      ).new_conversion end

    it { expect{subject}.to change(StoreCredit, :count).by(1) }
    it { expect{subject}.to change(FriendbuyConversionEvent, :count).by(1) }

    context 'referrer does not have an account' do
      it 'should give them pending store credit once they are a subscriber' do
        FriendbuyEvent.new(
          email: 'testcase@lootcrate.com',
          new_order_customer_id: '2',
          possible_self_referral: 'True',
          reward_amount: '5.00'
        ).new_conversion

        user = create(:user, email: 'testcase@lootcrate.com')

        expect(user.store_credits.count).to eq(1)
      end
    end
  end

end