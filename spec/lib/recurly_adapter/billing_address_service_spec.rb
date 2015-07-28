require 'rails_helper'

RSpec.describe RecurlyAdapter::BillingAddressService do
  let(:recurly_account_id) { Faker::Number.number(10) }
  let(:billing_address) { build :billing_address }
  let(:recurly_billing_address_service) { RecurlyAdapter::BillingAddressService.new recurly_account_id, billing_address }
  let(:recurly_account) { double('Recurly::Account') }

  describe '#update' do
    before do
      allow(Recurly::Account).to receive(:find).with(recurly_account_id) { recurly_account }
    end
    subject { recurly_billing_address_service.update }

    it 'calls Recurly::Account#save with billing address values' do
      expect(recurly_account).to receive_message_chain(:billing_info, :update_attributes) { true }
      subject
    end

    context 'Recurly::Account#update_attributes returns false' do
      let(:error_attribute) { :error_attribute }
      let(:error_messages) { ['Recurly::Account save error message'] }
      let(:recurly_account_errors) { { error_attribute => error_messages } }
      before do
        allow(recurly_account).to receive_message_chain(:billing_info, :errors) { recurly_account_errors }
        allow(recurly_account).to receive_message_chain(:billing_info, :update_attributes) { false }
        subject
      end

      describe 'expect recurly_billing_address_service accumulate & return recurly_account errors' do
        it 'expect recurly_billing_address_service to have some errors' do
          expect(recurly_billing_address_service.errors).not_to be_empty
        end

        it 'marks errors are coming from billing_address_service' do
          expect(recurly_billing_address_service.errors).to include(error_attribute)
        end

        it 'contains the recurly_account errors messages' do
          expect(recurly_billing_address_service.errors[error_attribute]).to match_array(error_messages)
        end
      end
    end
  end
end
