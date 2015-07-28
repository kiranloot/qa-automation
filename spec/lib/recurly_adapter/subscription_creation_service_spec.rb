require 'spec_helper'

describe RecurlyAdapter::SubscriptionCreationService do
  describe '#create_subscription' do
    let(:checkout) do build(:checkout,
      :with_billing_info,
      :with_shipping_info,
      :with_credit_card_info
    ) end
    let(:recurly_subscription) { double('recurly subscription') }

    before do
      @creator = RecurlyAdapter::SubscriptionCreationService.new(checkout, checkout.user)
      allow(Recurly::Subscription).to receive(:new).and_return(recurly_subscription)
    end

    it 'creates a subscription' do
      expect(recurly_subscription).to receive(:save!)
      @creator.create_subscription
    end

    it 'handles errors gracefully' do
      allow(recurly_subscription).to receive(:save!).and_raise('error')
      expect {@creator.create_subscription}.to_not raise_error
    end

    context 'transaction errors' do
      context 'credit card declined' do
        it 'sets error at the credit card number level' do
          allow(recurly_subscription).to receive(:save!).and_raise(StandardError, "declined")
          @creator.create_subscription
          
          expect(@creator.errors.messages).to include :credit_card_number
          expect(@creator.errors.messages[:credit_card_number]).to include 'declined'
        end
      end

      context 'bad billing address' do
        it 'sets error at the subscription gateway level' do
          allow(recurly_subscription).to receive(:save!).and_raise(StandardError, "Billing Address")
          @creator.create_subscription

          expect(@creator.errors.messages).to include :subscription_gateway
          expect(@creator.errors.messages[:subscription_gateway]).to include 'Billing Address'
        end
      end

      context 'bad zip code' do
        it 'sets error at the subscription gateway level' do
          allow(recurly_subscription).to receive(:save!).and_raise(StandardError, 'Tax')
          @creator.create_subscription

          expect(@creator.errors.messages).to include :subscription_gateway
          expect(@creator.errors.messages[:subscription_gateway]).to include 'Invalid zip code.'
        end
      end
    end

    context 'invalid resource errors' do

      let(:errors) { Recurly::Resource::Errors.new }
      let(:recurly_subscription) { double 'recurly_subscription', errors: errors }
      let(:billing_info) { double 'billing_info', errors: errors }
      let(:account) { double 'account', errors: errors }
      before do
        allow(@creator).to receive_messages(
          recurly_subscription: recurly_subscription,
          billing_info: billing_info,
          account: account
        )
        allow(recurly_subscription).to receive(:save!).and_raise(Recurly::Resource::Invalid, 'account is invalid')
      end

      context 'credit card name error' do
        it 'sets error at billing address full name level' do
          errors[:last_name] = ["can't be blank"]
          @creator.create_subscription
          expect(@creator.errors.messages).to include :billing_address_full_name
          expect(@creator.errors.messages[:billing_address_full_name]).to include "Last name can't be blank."
        end
      end

      context 'credit card number error' do
        it 'set error at credit card number level' do
          errors[:number] = ["is not a valid credit card number"]
          @creator.create_subscription

          expect(@creator.errors.messages).to include :credit_card_number
          expect(@creator.errors.messages[:credit_card_number]).to include "Number is not a valid credit card number."
        end
      end

      context 'cvv error' do
        it 'sets error at credit card cvv level' do
          errors[:verification_value] = ["must be three digits"]
          @creator.create_subscription

          expect(@creator.errors.messages).to include :credit_card_cvv
          expect(@creator.errors.messages[:credit_card_cvv]).to include "Verification value must be three digits."
        end
      end

      context 'expiration date error' do
        it 'sets error at credit card expiration date level' do
          errors[:number] = ["is expired or has an invalid expiration date"]
          @creator.create_subscription

          expect(@creator.errors.messages).to include :credit_card_expiration_date
          expect(@creator.errors.messages[:credit_card_expiration_date]).to include "Number is expired or has an invalid expiration date."
        end
      end

      context 'billing zip code error' do
        it 'sets error at the subscription gateway level' do
          errors[:zip] = ["is invalid"]
          @creator.create_subscription

          expect(@creator.errors.messages).to include :subscription_gateway
          expect(@creator.errors.messages[:subscription_gateway]).to include "Zip is invalid."
        end
      end

      context 'invalid coupon code error' do
        it 'sets error at the subscription gateway level' do
          errors[:coupon] = ["is invalid"]
          @creator.create_subscription

          expect(@creator.errors.messages).to include :subscription_gateway
          expect(@creator.errors.messages[:subscription_gateway]).to include "Coupon is invalid."
        end
      end
    end
  end

  describe '#subscription_hash' do
    let(:code) { 'coupon-code' }
    let(:checkout) { build :checkout, :with_billing_info, :with_shipping_info, :with_credit_card_info, coupon_code: code }
    subject { RecurlyAdapter::SubscriptionCreationService.new(checkout, checkout.user) }

    it 'should have the coupon_prefix from the promotion associated with thr coupon that matches @checkout.coupon_code' do
      promotion = create :promotion, coupon_prefix: 'promotion-coupon_prefix'
      create :coupon, code: code, promotion: promotion

      expect(subject.send(:subscription_hash)[:coupon_code]).to eq(promotion.coupon_prefix)
    end
  end
end
