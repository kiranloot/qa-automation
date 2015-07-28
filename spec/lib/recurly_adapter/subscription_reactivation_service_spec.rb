require 'spec_helper'

describe RecurlyAdapter::SubscriptionReactivationService do
  let(:promotion) { create :promotion }
  let(:coupon) { create :coupon, promotion: promotion }
  let(:service) { RecurlyAdapter::SubscriptionReactivationService.new(data) }
  let(:data) do
    instance_double(Subscription::ReactivationData,
                    current_plan_name: '1',
                    recurly_account_id: '1',
                    coupon_code: coupon.code
    )
  end

  describe "#reactivate" do
    context "when it successfully reactivates a subscription" do
      let(:account) { double('account') }
      let(:sub) { double('sub', uuid: '1') }

      before do
        allow(sub).to receive_message_chain(:errors, :presence) { nil }
        allow(Recurly::Subscription).to receive(:create!) { sub }
        allow(Recurly::Account).to receive(:find) { account }
      end

      it "creates a new recurly subscription" do
        params = { account: account, plan_code: data.current_plan_name, coupon_code: promotion.coupon_prefix }
        service.reactivate

        expect(Recurly::Subscription).to have_received(:create!)
                                     .with(params)
      end

      it "assigns the created subscription uuid" do
        service.reactivate

        expect(service.recurly_subscription_id).to eq sub.uuid
      end
    end

    context "when it fails to reactivate a subscription" do
      let(:data) {{ }}
      let(:error_msg) { 'RecurlyAdapter::SubscriptionReactivationService error message' }
      before do
        recurly_subscription = Recurly::Subscription.new
        errors = Recurly::Resource::Errors.new
        errors[:key] = [error_msg]
        allow(recurly_subscription).to receive_message_chain(:errors, :presence) { errors }
        allow(service).to receive(:create_subscription) { recurly_subscription }

        service.reactivate
      end

      describe 'accumulate reactivation errors' do
        it { expect(service.errors.any?).to be_truthy }
        it { expect(service.errors).to include(:key) }
        it { expect(service.errors[:key]).to include(error_msg) }
      end
    end
  end

  describe '#recurly_subscription_hash' do
    let(:account) { double 'Recurly::Account' }
    before { expect(service).to receive(:account) { account }}

    it { expect(service.send(:recurly_subscription_hash)).to be_a(Hash) }
    it { expect(service.send(:recurly_subscription_hash)).to include(:coupon_code) }
    it { expect(service.send(:recurly_subscription_hash)[:coupon_code]).to eq(promotion.coupon_prefix) }
  end

  describe '#create_subscription' do
    before { allow(Recurly::Subscription).to receive(:create!) }

    it 'calls recurly_subscription_hash' do
      expect(service).to receive(:recurly_subscription_hash) { Hash.new }
      service.send(:create_subscription)
    end
  end
end
