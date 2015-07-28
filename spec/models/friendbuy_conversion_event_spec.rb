require 'spec_helper'

describe FriendbuyConversionEvent do

  it { is_expected.to validate_uniqueness_of(:conversion_id) }

  describe 'belongs to user' do
    let(:user) { create(:user) }
    it 'ties user to friendbuy conversion' do
      friendbuy_conversion_event = create(:friendbuy_conversion_event, share_customer_id: user.id.to_s)
      expect(user.friendbuy_conversion_events.first).to eq(friendbuy_conversion_event)
    end

    context 'no email' do
      context 'has id' do
        it "still finds the user" do
          friendbuy_conversion_event = create(:friendbuy_conversion_event, share_customer_id: user.id.to_s)
          expect(user.friendbuy_conversion_events.first).to eq(friendbuy_conversion_event)
        end
      end
    end

    context 'no id' do
      context 'has email' do
        # WOULDBENICE to be able ot query both ids and emails
        #it 'still finds the user' do
        #  friendbuy_conversion_event = create(:friendbuy_conversion_event, email: user.email)
        #  expect(user.friendbuy_conversions.first).to eq(friendbuy_conversion_event)
        #end

        it 'will not raise an error' do
          friendbuy_conversion_event = create(:friendbuy_conversion_event, email: user.email)
          expect(friendbuy_conversion_event.referrer_user).to be_nil
        end
      end
    end
  end

  # comment validstes uniqueness in friendbuy conversion and uncomment the
  # following in order to test our database contraints
  #describe 'indexes' do
  #  let(:friendbuy_conversion) { create(friendbuy_conversion, conversion_id: '1') }
  #  it 'has db contraints on conversion id' do
  #    expect{FriendbuyConversion.create(conversion_id: '1')}.to raise_error(ActiveRecord::RecordNotUnique)
  #  end
  #end
end
