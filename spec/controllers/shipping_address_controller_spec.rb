require 'rails_helper'

RSpec.describe ShippingAddressController, type: :controller do
  include_context 'login_user'

  describe 'PUT #update' do
    let(:user) { @user }
    let(:subscription) { create :subscription, user: user }
    let(:shipping_address) { subscription.shipping_address }
    let(:new_first_name) { Faker::Name.first_name }
    let(:new_last_name) { Faker::Name.last_name }
    let(:new_line_1) { 'new ' + shipping_address.line_1 }
    let(:new_line_2) { 'new line 2' }
    let(:new_city) { Faker::Address.city }
    let(:new_two_letter_state_abbreviation) { Faker::Address.state_abbr }
    let(:new_zip) { Faker::Address.zip_code }
    let(:shipping_address_params) { {
      first_name: new_first_name,
      last_name:  new_last_name,
      line_1:     new_line_1,
      line_2:     new_line_2,
      city:       new_city,
      state:      new_two_letter_state_abbreviation,
      zip:        new_zip,
      country:    shipping_address.country
    } }
    let(:valid_params) { {
      id:               shipping_address.id,
      subscription_id:  subscription.id,
      shipping_address: shipping_address_params
    } }
    subject { xhr :patch, :update, valid_params }
    let(:recurly_account) { double('Recurly::Account', update_attributes: nil, save!: nil) }
    before do
      allow(Recurly::Account).to receive(:find) { recurly_account }
    end

    context 'with valid params' do
      describe 'updates shipping_address' do
        it 'updates first_name' do
          old_value = shipping_address.first_name
          expect { subject }.to change { shipping_address.reload.first_name }.from(old_value).to(new_first_name)
        end

        it 'updates last_name' do
          old_value = shipping_address.last_name
          expect { subject }.to change { shipping_address.reload.last_name }.from(old_value).to(new_last_name)
        end

        it 'updates line_1' do
          old_value = shipping_address.line_1
          expect { subject }.to change { shipping_address.reload.line_1 }.from(old_value).to(new_line_1)
        end

        it 'updates line_2' do
          old_value = shipping_address.line_2
          expect { subject }.to change { shipping_address.reload.line_2 }.from(old_value).to(new_line_2)
        end

        it 'updates city' do
          old_value = shipping_address.city
          expect { subject }.to change { shipping_address.reload.city }.from(old_value).to(new_city)
        end

        it 'updates state' do
          old_value = shipping_address.state
          expect { subject }.to change { shipping_address.reload.state }.from(old_value).to(new_two_letter_state_abbreviation)
        end

        it 'updates zip' do
          old_value = shipping_address.zip
          expect { subject }.to change { shipping_address.reload.zip }.from(old_value).to(new_zip)
        end
      end

      it 'calls RecurlyAdaptor::AccountService with shipping address values' do
        recurly_account = double('Recurly::Account', save!: nil)
        allow(Recurly::Account).to receive(:find) { recurly_account }

        expect(recurly_account).to receive(:update_attributes).with({
                                                                      first_name: shipping_address_params[:first_name],
                                                                      last_name:  shipping_address_params[:last_name],
                                                                      address:    {
                                                                        address1: shipping_address_params[:line_1],
                                                                        address2: shipping_address_params[:line_2],
                                                                        city:     shipping_address_params[:city],
                                                                        state:    shipping_address_params[:state],
                                                                        country:  shipping_address_params[:country],
                                                                        zip:      shipping_address_params[:zip]
                                                                      }
                                                                    })
        subject
      end

      describe 'response body' do
        render_views

        it 'renders update.js template' do
          subject
          expect(response).to render_template('update', format: 'js')
        end

        it 'renders shipping_address template' do
          subject
          expect(response).to render_template(partial: 'user_accounts/_shipping_address')
        end

        it 'response body contains new shipment info' do
          subject
          expect(response.body).to match(/#{ new_first_name }/)
        end
      end
    end

    context 'shipping_address is not valid' do
      let(:error_msg) { 'Error msg.' }
      before do
        allow(shipping_address).to receive(:valid?) { false }
        allow(shipping_address).to receive_message_chain(:errors, :full_messages) { [error_msg] }
        allow(controller).to receive(:shipping_address) { shipping_address }
      end

      it 'assigns @error_messages' do
        subject
        expect(assigns(:error_messages)).not_to be_nil
      end

      it '@error_messages contains error message' do
        subject
        expect(assigns(:error_messages)).to include(error_msg)
      end

      it 'does not update shipping_address' do
        expect { subject }.not_to change { shipping_address.reload.first_name }
      end

      it 'does not call Recurly' do
        recurly_account = double('Recurly::Account', save!: nil)
        allow(Recurly::Account).to receive(:find) { recurly_account }

        expect(recurly_account).not_to receive(:update_attributes)
        subject
      end

      describe 'response body' do
        render_views

        it 'renders the error message in the response body' do
          subject
          expect(response.body).to match(/#{ error_msg }/)
        end
      end
    end

    context 'shipping_address.save! throws exception' do
      let(:exception_msg) { 'System level problem.' }
      before do
        allow(shipping_address).to receive(:save!).and_raise(StandardError.new exception_msg)
        allow(controller).to receive(:shipping_address) { shipping_address }
      end

      it 'assigns @error_messages' do
        subject
        expect(assigns(:error_messages)).not_to be_nil
      end

      it '@error_messages contains error message' do
        subject
        expect(assigns(:error_messages)).to include(exception_msg)
      end

      it 'does not update shipping_address' do
        expect { subject }.not_to change { shipping_address.reload.first_name }
      end

      it 'does not call Recurly' do
        recurly_account = double('Recurly::Account', save!: nil)
        allow(Recurly::Account).to receive(:find) { recurly_account }

        expect(recurly_account).not_to receive(:update_attributes)
        subject
      end

      describe 'response body' do
        render_views

        it 'renders the error message in the response body' do
          subject
          expect(response.body).to match(/#{ exception_msg }/)
        end
      end
    end

    context 'recurly_shipping_service.update throws exception' do
      let(:exception_msg) { 'System level problem.' }
      before do
        recurly_shipping_address_service = instance_double(RecurlyAdapter::ShippingAddressService)
        allow(recurly_shipping_address_service).to receive(:update).and_raise(StandardError.new exception_msg)
        allow(controller).to receive(:shipping_address_service) { recurly_shipping_address_service }
      end

      it 'assigns @error_messages' do
        subject
        expect(assigns(:error_messages)).not_to be_nil
      end

      it '@error_messages contains error message' do
        subject
        expect(assigns(:error_messages)).to include(exception_msg)
      end

      it 'does not update shipping_address' do
        expect { subject }.not_to change { shipping_address.reload.first_name }
      end

      describe 'response body' do
        render_views

        it 'renders the error message in the response body' do
          subject
          expect(response.body).to match(/#{ exception_msg }/)
        end
      end
    end
  end
end
