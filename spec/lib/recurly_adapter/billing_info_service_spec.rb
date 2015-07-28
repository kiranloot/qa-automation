require 'spec_helper'

describe RecurlyAdapter::BillingInfoService do

  describe '#update_billing' do
    let(:sub) { double('sub', recurly_account_id: '1') }
    let(:payment_method_hash) { {number: '4222222222222220'} }
    let(:billing_info) { double('billing_info', errors: '') }

    it 'fetches billing info' do
      account = double('account', billing_info: billing_info)
      allow(billing_info).to receive(:update_attributes)

      expect(Recurly::Account).to receive(:find).and_return(account)

      billing_update_service = RecurlyAdapter::BillingInfoService.new(sub)
      billing_update_service.update(payment_method_hash)
    end

    it 'updates billing info' do
      account = double('account', billing_info: billing_info)
      allow(Recurly::Account).to receive(:find).and_return(account)

      expect(billing_info).to receive(:update_attributes).and_return(true)

      billing_update_service = RecurlyAdapter::BillingInfoService.new(sub)
      billing_update_service.update(payment_method_hash)
    end

    it 'sets error if something bad occured' do
      account = double('account', billing_info: billing_info)
      allow(Recurly::Account).to receive(:find).and_return(account)

      expect(billing_info).to receive(:update_attributes).and_raise

      billing_update_service = RecurlyAdapter::BillingInfoService.new(sub)
      billing_update_service.update(payment_method_hash)
      expect(billing_update_service.errors.any?).to eq(true)
    end
  end

end
