require 'spec_helper'

describe ReferralCreditRedeemer do
  describe '#process' do
    let(:store_credit) { create(:store_credit, referrer_user_email: 'test@mailinator.com',
                                amount: 5, referrer_user_id: nil) }
    let(:redeemer) { ReferralCreditRedeemer.new(store_credit) }
    context 'successful referral' do
      it 'calls credit referrer' do
        allow(redeemer).to receive(:redeemable?).and_return(true)
        expect(redeemer).to receive(:credit_referrer)
        redeemer.process
      end
    end

    context 'not redeemable' do
      it 'does not credit referrer' do
        allow(redeemer).to receive(:redeemable?).and_return(false)
        expect(redeemer).not_to receive(:credit_referrer)
        redeemer.process
      end
    end
  end

  describe '#credit_referrer' do
    context 'no subscriptions' do
      let(:referrer_user) { create(:user) }
      let(:store_credit) { create(:store_credit, referrer_user_email: 'test@mailinator.com',
                                  amount: 5, referrer_user_id: referrer_user.id) }
      let(:redeemer) { ReferralCreditRedeemer.new(store_credit) }

      it 'set store credit to active' do
        redeemer.credit_referrer
        expect(store_credit.status).to eq('active')
      end
    end

    context 'inactive subscriptions' do
      let(:referrer_user) { create(:user) }
      let(:store_credit) { create(:store_credit, referrer_user_email: 'test@mailinator.com',
                                  amount: 5, referrer_user_id: referrer_user.id) }
      let(:redeemer) { ReferralCreditRedeemer.new(store_credit) }

      it 'set store credit to active' do
        redeemer.credit_referrer
        expect(store_credit.status).to eq('active')
      end
    end

    context 'has active subscription' do
      let(:referred_user) { create(:user) }
      let(:store_credit) { create(:store_credit, referrer_user_email: referred_user.email,
                                  amount: 5, referrer_user_id: referred_user.id) }
      let(:redeemer) { ReferralCreditRedeemer.new(store_credit) }

      it 'should give credit active sub' do
        create(:subscription,
                subscription_status: 'active',
                user: referred_user)
        expect(store_credit).to receive(:redeem)
        redeemer.credit_referrer
      end

      it 'gives credit to oldest active sub' do
        redeemer.credit_referrer
      end
    end
  end

  describe '#redeemable?' do
    let!(:referred_user) { create(:user) }
    let(:store_credit) { create(:store_credit,
                                referrer_user_email: 'test@mailinator.com',
                                referred_user_id: referred_user.id,
                                amount: 5)
    }
    let!(:subscription) { create(:subscription, user: referred_user) }

    it 'returns true for subscriptions with units' do
      redeemer = ReferralCreditRedeemer.new(store_credit)
      allow_any_instance_of(Subscription).to receive(:current_unit) { "current_unit" }

      expect(redeemer.redeemable?).to be(true)
    end

    it 'return false if subscription units has been found' do
      redeemer = ReferralCreditRedeemer.new(store_credit)
      allow_any_instance_of(Subscription).to receive(:current_unit) { nil }

      expect(redeemer.redeemable?).to be(false)
    end
  end

  describe '.process_all' do
    # Not yet implemented
  end

end
