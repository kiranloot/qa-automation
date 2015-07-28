require 'spec_helper'

describe UserAccountHelper do
  describe "#reactivation_available_for(subscription)" do
    let(:subscription) { create(:subscription) }

    context "when subscription's status is NOT active/past_due" do
      it "returns reactivation link" do
        subscription.subscription_status = 'canceled'
        reactivation_link = helper.link_to('Reactivate', reactivation_subscription_path(subscription))

        expect(helper.reactivation_available_for(subscription)).to eq reactivation_link
      end
    end

    context "when subscription's plan is amiibo" do
      it "returns nil" do
        subscription.update_attributes(subscription_status: 'canceled')
        subscription.plan.update_attributes(name: 'amiibo-crate-single-payment')

        expect(helper.reactivation_available_for(subscription)).to eq nil
      end
    end

    context "when subscription's status is active" do
      it "returns nil" do
        subscription.subscription_status = 'active'

        expect(helper.reactivation_available_for(subscription)).to eq nil
      end
    end

    context "when subscription's status is past_due" do
      it "returns nil" do
        subscription.subscription_status = 'past_due'

        expect(helper.reactivation_available_for(subscription)).to eq nil
      end
    end
  end

  describe "#masked_payment_info" do
    let(:subscription) { create(:subscription) }

    it 'returns masked credit number' do
      credit_card = double('credit_card', masked_card_number: 'XXXX-XXXX-XXXX-1234')
      chargify_subscription = double('chargify subscription', credit_card: credit_card)

      allow(subscription).to receive(:get_chargify_subscription).and_return(chargify_subscription)

      expect(helper.masked_card_number(subscription.get_chargify_subscription)).to eq ("XXXX-XXXX-XXXX-1234")
    end

    context 'payment info is unavailable' do
      it 'returns unavailable text' do
        chargify_subscription = double('chargify subscription', credit_card: nil)

        allow(subscription).to receive(:get_chargify_subscription).and_return(chargify_subscription)

        expect(helper.masked_card_number(subscription.get_chargify_subscription).downcase).to match(/unavailable/)
      end
    end
  end

  describe "#includes_shirt?" do
    let(:subscription) { create(:subscription) }

    it "returns true for core crate plans" do
      subscription.plan.product = Product.create(name: 'Core Crate')

      expect(helper.includes_shirt?(subscription)).to be true
    end
    it "returns true for premium wearable level up plans" do
      subscription.plan.product = Product.create(name: 'Premium Wearable')

      expect(helper.includes_shirt?(subscription)).to be true
    end
    it "returns false for non-shirt plans" do
      subscription.plan.product = Product.create(name: 'Sock It To Me')

      expect(helper.includes_shirt?(subscription)).to be false
    end
  end
end
