require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  include_context 'login_admin'

  let(:user) { create :user }
  let(:resource) { User.find(user.id) }
  let(:error_key) { :error_key }
  let(:error_msg) { 'error_msg' }
  let(:errors) do
    @errors = ActiveModel::Errors.new(resource)
    @errors.add error_key, error_msg
    @errors
  end

  describe 'PUT #update' do
    let(:new_full_name) { Faker::Name.name }
    let(:new_password) { 'new_password' }
    let(:valid_parameters) { {
      id: user.id, user: {
        email:                 user.email,
        full_name:             new_full_name,
        password:              new_password,
        password_confirmation: new_password
      }
    } }
    subject { put :update, valid_parameters }

    it 'updates the record' do
      expect { subject }.to change { user.reload.updated_at }
    end

    it 'sets success flash' do
      subject

      expect(controller.flash[:success]).to match(/Update successful/i)
    end

    it 'redirects to admin/users#show' do
      subject
      expect(response).to redirect_to(action: 'show')
    end

    context 'password is empty' do
      before { valid_parameters[:user][:password] = '' }

      it 'password is not updated' do
        expect { subject }.not_to change { user.reload.encrypted_password }
      end

      it 'password_confirmation is not updated' do
        expect { subject }.not_to change { user.reload.password_confirmation }
      end
    end

    context "user_params['locked_at'] == '1'" do
      before do
        user.lock_access!
        valid_parameters[:user][:locked_at] = '1'
      end

      it 'calls unlock_access!' do
        expect { subject }.to change { user.reload.access_locked? }.from(true).to(false)
      end
    end

    it 'locked_at is not updated' do
      valid_parameters[:user][:locked_at] = '1'
      expect { subject }.not_to change { user.reload.locked_at }
    end

    context 'update returns errors' do
      before do
        allow(resource).to receive(:valid?) { false }
        allow(resource).to receive(:errors) { errors }
        allow(User).to receive(:find) { resource }
      end

      it 'sets alert flash' do
        subject
        expect(controller.flash.to_hash).to include('alert')
      end

      it 'notifies the user with the errors' do
        subject
        expect(controller.flash.to_hash['alert']).to match(/Error key #{ error_msg }/)
      end

      it 'assigns @user' do
        subject
        expect(assigns(:user)).not_to be_nil
      end

      it 'discards changes to user' do
        subject
        expect(assigns(:user)).to eq(user)
      end

      it 'renders edit' do
        expect(subject).to render_template(:edit)
      end
    end

    context 'params[:user][:email] != user.email' do
      let(:new_email) { Faker::Internet.email }
      before do
        valid_parameters[:user][:email] = new_email
        1..3.times do
          create(:subscription, user: user)
        end

        user.subscriptions.each do |subscription|
          recurly_account_service = instance_double(RecurlyAdapter::AccountService)
          allow(RecurlyAdapter::AccountService).to receive(:new).with(subscription.recurly_account_id) { recurly_account_service }
          allow(recurly_account_service).to receive(:update).with(email: new_email)
        end
      end

      it 'updates user profile with new email' do
        old_email = user.email
        expect { subject }.to change { user.reload.email }.from(old_email).to(new_email)
      end

      it 'updates all Recurly accounts' do
        user.subscriptions.delete_all
        1..3.times do
          subscription            = create(:subscription, user: user)
          recurly_account_service = instance_spy(RecurlyAdapter::AccountService)
          expect(RecurlyAdapter::AccountService).to receive(:new).with(subscription.recurly_account_id) { recurly_account_service }
          expect(recurly_account_service).to receive(:update).with(email: new_email)
        end

        subject
      end

      context 'email_changer returns errors' do
        let(:resource) { User.find(user.id) }
        before do
          email_changer = User::EmailChanger.new resource, new_email
          allow(email_changer).to receive(:perform)
          allow(email_changer).to receive(:errors) { errors }
          allow(User::EmailChanger).to receive(:new).with(resource, new_email) { email_changer }
        end

        it 'notifies the user via flash[:alert]' do
          subject
          expect(controller.flash.to_hash).to include('alert')
        end

        it 'notifies the user with the errors' do
          subject
          expect(controller.flash.to_hash['alert']).to match(/Error key #{ error_msg }/)
        end

        it 'assigns @user' do
          subject
          expect(assigns(:user)).not_to be_nil
        end

        it 'renders #edit' do
          subject
          expect(subject).to render_template(:edit)
        end
      end

      context 'email_changer throws an exception' do
        before do
          resource = User.find(user.id)
          allow(User).to receive(:find) { resource }
          email_changer = instance_double(User::EmailChanger)
          allow(email_changer).to receive(:perform).and_raise(StandardError)
          allow(User::EmailChanger).to receive(:new).with(resource, new_email) { email_changer }
        end

        it 'processes the exception with notify_airbrake' do
          expect(controller).to receive(:notify_airbrake)
          subject
        end

        it 'notifies the user via flash[:error]' do
          subject
          expect(controller.flash.to_hash).to include('error')
        end

        it 'renders #edit' do
          subject
          expect(subject).to render_template(:edit)
        end
      end
    end
  end
end
