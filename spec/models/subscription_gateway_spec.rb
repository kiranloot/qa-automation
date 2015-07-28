require 'spec_helper'

describe SubscriptionGateway do
  let(:user) { create(:user) }
  let(:checkout) do
    build(:checkout,
      :with_billing_info,
      :with_shipping_info,
      :with_credit_card_info
    )
  end
  let(:gateway) { SubscriptionGateway.new(checkout, user) }


  describe "#create_subscription" do
    context "when it successfully creates a subscription" do
      it "sets a subscription instance" do
        chargify_subscription = double("chargify_subscription", :errors => {})
        expect(Chargify::Subscription).to receive(:create).and_return(chargify_subscription)

        gateway.create_subscription

        expect(gateway.subscription).to eq(chargify_subscription)
      end
    end

    context "when it fails to create a subscription" do
      it "adds error(s)" do
        chargify_subscription = double("chargify_subscription", :errors => {:error => ['test error']})
        expect(Chargify::Subscription).to receive(:create).and_return(chargify_subscription)

        gateway.create_subscription

        expect(gateway.errors.any?).to be true
      end
    end
  end

  describe '.readjust_rebilling_date' do
    let(:subscription) { create(:subscription) }
    let(:new_billing_date) { DateTime.new(2016, 02, 07) }
    
    context 'valid subscription id' do
      it 'uses gateway api to readjust rebilling date' do
        chargify_subscription = double("chargify_subscription", :next_billing_at= => nil, :save => nil)
        expect(Chargify::Subscription).to receive(:find).and_return(chargify_subscription)
        
        expect(SubscriptionGateway.readjust_rebilling_date(subscription, new_billing_date)).to eq(true)
      end
    end

    context 'invalid subscription id' do
      it "returns false when subscription id is invalid" do
        chargify_subscription = double("chargify_subscription")
        expect(Chargify::Subscription).to receive(:find).and_return(nil)

        expect(SubscriptionGateway.readjust_rebilling_date(subscription, new_billing_date)).to eq(false)
      end
    end
  end
end