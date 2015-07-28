require 'spec_helper'

describe CreditCard do
  context "validations" do
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:cvv) }

    it 'validates expiration date' do
      expect(FactoryGirl.build(:credit_card)).to be_valid
    end

    it '#not_expired? adds error if invalid' do
      credit_card = FactoryGirl.build(:expired_credit_card)
#      credit_card.expiration = Date.new(2012, 1, 31)
      credit_card.not_expired?
      expect(credit_card.errors.keys).to eq([:expiration])
    end
  end

  it 'sanitizes select_tag params from subscription submission' do
    cc_params = {
      'expiration(1i)' => '2099',
      'expiration(2i)' => '1',
      'expiration(3i)' => '1'
    }
    CreditCard.sanitize_expiration(cc_params)
    expect(cc_params[:expiration]).to be_a Date
  end
end
