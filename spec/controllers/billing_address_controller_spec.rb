require 'spec_helper'

describe BillingAddressController do
  include_context 'login_user'
  include_context 'force_ssl'

  describe 'PUT update' do
    let(:user) { @user }
    let(:subscription) { create :subscription, user: user }
    let(:billing_address) { subscription.billing_address }
    let(:new_line_1) { Faker::Address.street_address }
    let(:new_line_2) { Faker::Address.secondary_address }
    let(:new_city) { Faker::Address.city }
    let(:new_two_letter_state_abbreviation) { Faker::Address.state_abbr }
    let(:new_zip) { Faker::Address.zip_code }
    let(:billing_address_params) { {
      line_1:  new_line_1,
      line_2:  new_line_2,
      city:    new_city,
      state:   new_two_letter_state_abbreviation,
      zip:     new_zip,
      country: billing_address.country
    } }
    let(:valid_params) { {
      id:              billing_address.id,
      subscription_id: subscription.id,
      billing_address: billing_address_params
    } }
    let(:recurly_account) { double 'Recurly::Account' }
    before do
      allow(recurly_account).to receive_message_chain(:billing_info, :update_attributes) { true }
      allow(Recurly::Account).to receive(:find).with(subscription.recurly_account_id) { recurly_account }
    end
    subject { xhr :patch, :update, valid_params }

    describe 'updates billing_address' do
      it 'updates line_1' do
        old_value = billing_address.line_1
        expect { subject }.to change { billing_address.reload.line_1 }.from(old_value).to(new_line_1)
      end

      it 'updates line_2' do
        old_value = billing_address.line_2
        expect { subject }.to change { billing_address.reload.line_2 }.from(old_value).to(new_line_2)
      end

      it 'updates city' do
        old_value = billing_address.city
        expect { subject }.to change { billing_address.reload.city }.from(old_value).to(new_city)
      end

      it 'updates state' do
        old_value = billing_address.state
        expect { subject }.to change { billing_address.reload.state }.from(old_value).to(new_two_letter_state_abbreviation)
      end

      it 'updates zip' do
        old_value = billing_address.zip
        expect { subject }.to change { billing_address.reload.zip }.from(old_value).to(new_zip)
      end
    end

    it 'calls Recurly::Account#update_attributes' do
      expect(recurly_account).to receive_message_chain(:update_attributes, :save) { true }
      subject
    end

    describe 'response body' do
      render_views

      it 'renders update.js template' do
        subject
        expect(response).to render_template('update', format: 'js')
      end

      it 'renders billing_address template' do
        subject
        expect(response).to render_template(partial: 'user_accounts/_billing_address')
      end

      it 'response body contains new billing info' do
        subject
        expect(response.body).to match(/#{ new_city }/)
      end
    end

    context 'BillingAddress::Changer returns errors' do
      let(:attribute_key) { :random_key }
      let(:error_message) { 'billing_address error message' }
      let(:billing_address_changer) { BillingAddress::Changer.new billing_address, subscription, billing_address_params }
      before do
        billing_address_changer.errors.add attribute_key, error_message
        allow(controller).to receive(:billing_address_changer) { billing_address_changer }
        allow(controller).to receive(:billing_address) { billing_address }
      end

      it 'does not update billing_address' do
        expect { subject }.not_to change { billing_address.reload.updated_at }
      end

      it 'assigns @error_messages' do
        subject
        expect(assigns(:error_messages)).not_to be_nil
      end

      it '@error_messages contains error message' do
        subject
        expect(assigns(:error_messages)).to include("#{ attribute_key.to_s } #{ error_message }")
      end

      it 'does not call Recurly' do
        recurly_account = double('Recurly::Account')
        allow(Recurly::Account).to receive(:find) { recurly_account }

        expect(recurly_account).not_to receive(:update_attributes)
        subject
      end

      describe 'response body' do
        render_views

        it 'renders the error message in the response body' do
          subject
          expect(response.body).to match(/#{ attribute_key.to_s } #{ error_message }/)
        end
      end
    end

    context 'BillingAddress::Changer raises an exception'do
      let(:billing_address_changer) { instance_double BillingAddress::Changer }
      let(:exception_message) { Faker::Lorem.sentence }
      before do
        allow(controller).to receive(:billing_address_changer) { billing_address_changer }
        allow(controller).to receive(:billing_address) { billing_address }
        allow(billing_address_changer).to receive(:perform).and_raise(StandardError, exception_message)
      end

      it 'does not update billing_address' do
        expect { subject }.not_to change { billing_address.reload.updated_at }
      end

      it 'assigns @error_messages' do
        subject
        expect(assigns(:error_messages)).not_to be_nil
      end

      it '@error_messages contains error message' do
        subject
        expect(assigns(:error_messages)).to include(exception_message)
      end

      it 'does not call Recurly' do
        recurly_account = double('Recurly::Account')
        allow(Recurly::Account).to receive(:find) { recurly_account }

        expect(recurly_account).not_to receive(:update_attributes)
        subject
      end

      describe 'response body' do
        render_views

        it 'renders the error message in the response body' do
          subject
          expect(response.body).to match(/#{ exception_message }/)
        end
      end
    end
  end
end
