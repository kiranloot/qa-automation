require 'spec_helper'

describe StoreCredit do

  it { is_expected.to validate_presence_of(:amount) }

  describe '#redeem' do
    let(:store_credit) { create(:store_credit,
        referred_user_id: 1,
        amount: 5,status: 'pending',
        referrer_user_id: 1) }
    let(:chargify_sub) { double('chargify_sub') }

    it 'gives referrer an adjustment for redeemable store credit' do
      expect_any_instance_of(ChargifyAdapter::AdjustmentService).to receive(:create)
      store_credit.redeem(chargify_sub)
    end
  end

end
