require 'spec_helper'

describe UserAccountsController, type: :controller do
  include_context 'login_user'
  include_context 'force_ssl'
  let!(:subscription) { build(:subscription, user: @user) }

  describe "GET #index" do
    it 'renders the index view' do
      get :index

      expect(response).to render_template :index
    end
  end

  describe "GET #subscriptions" do
    it "assigns upgradable_subscriptions" do
      plan  = create(:plan_3_months)
      plan2 = create(:plan_6_months)
      plan3 = create(:plan_12_months)
      sub1 = create(:subscription, plan: plan, user: @user)
      sub2 = create(:subscription, plan: plan2, user: @user)
      create(:subscription, plan: plan3)
      upgradable_subscriptions = [sub1, sub2]
      @user.subscriptions << upgradable_subscriptions
      @user.save

      get :subscriptions

      expect(assigns(:upgradable_subscriptions)).to match_array upgradable_subscriptions
    end
  end

  describe 'post #update_email' do
    let(:new_email) { Faker::Internet.email }
    let(:valid_params) { { user: { email: new_email } } }
    before do
      @user.subscriptions.each do |subscription|
        recurly_account_service = RecurlyAdapter::AccountService.new(subscription.recurly_account_id)
        allow(RecurlyAdapter::AccountService).to receive(:new).with(subscription.recurly_account_id) { recurly_account_service }
        allow(recurly_account_service).to receive(:update).with(email: new_email)
      end
    end

    it { expect(controller.current_user).to eq(@user) }

    context 'no change in email' do
      let(:valid_params) { { user: { email: @user.email } } }
      before { post :update_email, valid_params }

      it { is_expected.not_to set_flash[:error] }
      it { is_expected.not_to set_flash[:notice] }
      it { is_expected.not_to set_flash[:success] }
      it { is_expected.to redirect_to user_accounts_path }
    end

    context 'email changed' do
      it 'updates user profile with new email' do
        old_email = @user.email
        expect { post :update_email, valid_params }.to change { @user.reload.email }.from(old_email).to(new_email)
      end

      it 'updates all Recurly accounts' do
        1..3.times do
          subscription            = create(:subscription, user: @user)
          recurly_account_service = instance_spy(RecurlyAdapter::AccountService)
          expect(RecurlyAdapter::AccountService).to receive(:new).with(subscription.recurly_account_id) { recurly_account_service }
          expect(recurly_account_service).to receive(:update).with(email: new_email)
        end

        post :update_email, valid_params
      end

      it { post :update_email, valid_params; is_expected.to set_flash[:success] }
      it { post :update_email, valid_params; is_expected.to redirect_to user_accounts_path }

      context 'email_changer returns errors' do
        let(:email_changer) { User::EmailChanger.new controller.current_user, new_email }
        let(:errors) { ActiveModel::Errors.new controller.current_user }
        before do
          allow(email_changer).to receive(:perform)
          errors.add :key, 'error msg'
          allow(email_changer).to receive(:errors) { errors }
          allow(User::EmailChanger).to receive(:new).with(controller.current_user, new_email) { email_changer }
        end

        it { post :update_email, valid_params; is_expected.to set_flash[:error] }
        it { post :update_email, valid_params; is_expected.to redirect_to user_accounts_path }
      end

      context 'email_changer throws an exception' do
        before do
          email_changer = instance_double(User::EmailChanger)
          allow(email_changer).to receive(:perform).and_raise(StandardError)
          allow(User::EmailChanger).to receive(:new).with(controller.current_user, new_email) { email_changer }
        end

        it 'processes the exception with notify_airbrake' do
          expect(controller).to receive(:notify_airbrake)

          post :update_email, valid_params
        end
        it { post :update_email, valid_params; is_expected.to set_flash[:error] }
        it { post :update_email, valid_params; is_expected.to redirect_to user_accounts_path }
      end
    end
  end
end
