require 'rails_helper'

RSpec.describe BillingAddress::Changer, type: :model do
  let(:subscription) { create :subscription }
  let(:billing_address) { subscription.billing_address }
  let(:new_first_name) { Faker::Name.first_name }
  let(:new_last_name) { Faker::Name.last_name }
  let(:new_line_1) { 'new ' + billing_address.line_1 }
  let(:new_line_2) { 'new line 2' }
  let(:new_city) { Faker::Address.city }
  let(:new_two_letter_state_abbreviation) { Faker::Address.state_abbr }
  let(:new_zip) { Faker::Address.zip_code }
  let(:billing_address_params) { {
    first_name: new_first_name,
    last_name:  new_last_name,
    line_1:     new_line_1,
    line_2:     new_line_2,
    city:       new_city,
    state:      new_two_letter_state_abbreviation,
    zip:        new_zip,
    country:    billing_address.country
  } }
  let(:billing_address_changer) { BillingAddress::Changer.new billing_address, subscription, billing_address_params }
  let(:recurly_account) { double 'Recurly::Account' }
  before do
    allow(recurly_account).to receive_message_chain(:billing_info, :update_attributes) { true }
    allow(Recurly::Account).to receive(:find).with(subscription.recurly_account_id) { recurly_account }
  end

  describe '#peform' do
    subject { billing_address_changer.perform }

    it 'updates billing address' do
      old_city = billing_address.city
      expect { subject }.to change { billing_address.reload.city }.from(old_city).to(new_city)
    end

    it 'calls Recurly::Account save' do
      expect(recurly_account).to receive_message_chain(:billing_info, :update_attributes) { true }
      subject
    end

    context 'billing_address is invalid' do
      let(:attribute_key) { :random_key }
      let(:error_message) { 'billing_address error message' }
      before do
        allow(billing_address).to receive(:valid?) { false }
        billing_address.errors.add attribute_key, error_message
      end

      it 'does not update billing_address record' do
        expect { subject }.not_to change { billing_address.reload.city }
      end

      it 'does not call Recurly::Account save' do
        expect(recurly_account).not_to receive(:billing_infos)
        subject
      end

      it 'billing_address_changer.errors contains an error' do
        subject
        expect(billing_address_changer.errors).not_to be_empty
      end

      it 'billing_address_changer.errors communicates the attribute key' do
        subject
        expect(billing_address_changer.errors).to include(attribute_key)
      end

      it 'billing_address_changer.errors communicates the error message' do
        subject
        expect(billing_address_changer.errors[attribute_key]).to include(error_message)
      end
    end

    context 'billing_address update raises an exception' do
      let(:exception_message) { Faker::Lorem.sentence }
      before { allow(billing_address).to receive(:save!).and_raise(StandardError, exception_message) }

      it 'does not update billing_address record' do
        expect {
          begin
            subject
          rescue
          end
        }.not_to change { billing_address.reload.city }
      end

      it 'does not call Recurly::Account save' do
        expect(recurly_account).not_to receive(:billing_info)
        begin
          subject
        rescue
        end
      end

      it 'raises the exception' do
        expect { subject }.to raise_error
      end

      it 'exception preserves message' do
        expect { subject }.to raise_error(exception_message)
      end
    end

    context 'Recurly::Account save fails'
  end
end
