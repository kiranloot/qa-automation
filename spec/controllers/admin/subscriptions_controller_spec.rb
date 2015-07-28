require 'spec_helper'

describe Admin::SubscriptionsController do
  include_context 'login_admin'
  include_context 'force_ssl'

  let(:subscription) { create(:subscription) }
  before do
    request.env["HTTP_REFERER"] = 'https://test.hostback'
  end

  describe "PUT #undo_cancellation_at_end_of_period" do
    before do
      subscription.update_attributes(cancel_at_end_of_period: true)
      allow_any_instance_of(RecurlyAdapter::SubscriptionCancellationService).to receive(:remove_cancel_at_end_of_period)
    end
    context 'when cancellation succeeds' do
      before do
        allow_any_instance_of(RecurlyAdapter::SubscriptionCancellationService).to receive(:errors).and_return(nil)
        put :undo_cancellation_at_end_of_period, id: subscription.id
      end
      it 'removes subscription cancellation' do
        subscription.reload

        expect(subscription.cancel_at_end_of_period).to be_nil
      end

      it { is_expected.to set_flash[:success] }
      it { is_expected.to redirect_to :back }
    end
    context 'when undo cancellation fails' do
      let(:errors) { ActiveModel::Errors.new(subscription) }
      before do
        errors.add(:test, 'test error')
        allow_any_instance_of(RecurlyAdapter::SubscriptionCancellationService).to receive(:errors).and_return(errors)
        put :undo_cancellation_at_end_of_period, id: subscription.id
      end

      it 'does not update subscription cancellation flag' do
        subscription.reload

        expect(subscription.cancel_at_end_of_period).to be true
      end

      it { is_expected.to set_flash[:error] }
      it { is_expected.to redirect_to :back }
    end
  end

  describe "PUT #cancel_immediately" do
    context "when it successfully cancels immediately" do
      before do
        allow_any_instance_of(Subscription::Canceller).to receive_messages(
          :cancel_immediately =>  nil,
          :errors => nil
        )

        put :cancel_immediately, id: subscription.id
      end

      it { is_expected.to redirect_to :back }
      it { is_expected.to set_flash[:success] }
    end

    context "when it fails to cancel immediately" do
      before do
        allow_any_instance_of(Subscription::Canceller).to receive_messages(
          :cancel_immediately =>  nil,
          :errors => {cancel_immediately: ['test error']}
        )
        put :cancel_immediately, id: subscription.id
      end

      it { is_expected.to redirect_to :back }
      it { is_expected.to set_flash[:error] }
    end
  end

  describe "PUT cancel_at_end_of_period" do
    before do
      allow_any_instance_of(RecurlyAdapter::SubscriptionCancellationService).to receive_messages(
        :cancel_at_end_of_period => nil,
        :errors => nil,
        :subscription_expiration_date => Date.today
      )
    end

    context "when it successfully cancels at end of period" do
      before do
        put :cancel_at_end_of_period, id: subscription.id
      end

      it "assigns @subscription" do
        expect(assigns(:subscription)).to eq subscription
      end

      it "changes cancel_at_end_of_period to true" do
        subscription.reload
        expect(subscription.cancel_at_end_of_period).to eq true
      end

      it { is_expected.to redirect_to :back }
      it { is_expected.to set_flash[:success] }
    end

    context "when it fails to cancel at end of period" do
      before do
        allow_any_instance_of(Subscription).to receive(:cancel_at_end_of_period).and_return(nil)

        put :cancel_at_end_of_period, id: subscription.id
      end

      it { is_expected.to set_flash[:error] }
    end
  end

  describe "PUT #reactivate" do
    let(:reactivator) { instance_double(Subscription::Reactivator) }
    before do
      subscription.update_attributes(subscription_status: 'expired')
      allow(Subscription::Reactivator).to receive(:new).and_return(reactivator)
      allow(reactivator).to receive_messages(
        :reactivate => nil,
        :errors     => {}
      )
      put :reactivate, id: subscription.id
    end

    context 'when it successfully reactivates' do
      it "reactivates subscription" do
        expect(reactivator).to have_received(:reactivate)
      end

      it { is_expected.to redirect_to :back}
      it { is_expected.to set_flash[:notice] }
    end

    context "when it fails to reactivate" do
      before do
        allow(reactivator).to receive(:errors).and_return( { reactivate: 'test error' } )
        put :reactivate, id: subscription.id
      end

      it "assigns @subscription" do
        expect(assigns(:subscription)).to eq subscription
      end

      it { is_expected.to redirect_to :back}
      it { is_expected.to set_flash[:error] }
    end
  end

  describe '#redeem' do
    context 'redeems successfully' do
      before do
        allow_any_instance_of(Subscription).to receive(:redeem_store_credits).and_return(true)

        put :redeem_store_credits, id: subscription.id
      end

      it { is_expected.to redirect_to :back }
      it { is_expected.to set_flash[:success] }
    end
  end

  describe '#flag' do
    context 'when flag is successfully set' do
      before do
        put :flag, id: subscription.id
      end

      it 'sets shipping_address.flagged_invalid_at to current date time' do
        subscription.reload
        expect(subscription.shipping_address.flagged_invalid_at).to be_an_instance_of ActiveSupport::TimeWithZone
      end
      it 'creates a paper_trail_event for the shipping address', versioning: true do
        expect(subscription.shipping_address.versions.last.event).to eq 'Flagged invalid address'
      end
      it { is_expected.to set_flash[:notice] }
      it { is_expected.to redirect_to admin_subscription_path(subscription) }
    end

    context 'when shipping_address attribute update fails' do
      before do
        allow_any_instance_of(ShippingAddress).to receive(:update_attributes).and_return(false)
        put :flag, id: subscription.id
      end

      it { is_expected.to set_flash[:error].now }
      it { is_expected.to render_template :edit }
    end
  end

  describe '#unflag' do
    before do
      subscription.shipping_address.update_attributes(flagged_invalid_at: DateTime.now)
    end

    context 'when flag is successfully unset' do
      before do
        put :unflag, id: subscription.id
      end
      it 'sets shipping_address.flagged_invalid_at to nil' do
        subscription.reload
        expect(subscription.shipping_address.flagged_invalid_at).to be_nil
      end
      it 'creates a paper_trail_event for the shipping address', versioning: true do
        expect(subscription.shipping_address.versions.last.event).to eq 'Invalid address flag removed'
      end
      it { is_expected.to set_flash[:notice] }
      it { is_expected.to redirect_to admin_subscription_path(subscription) }
    end

    context 'when shipping_address attribute update fails' do
      before do
        allow_any_instance_of(ShippingAddress).to receive(:update_attributes).and_return(false)
        put :flag, id: subscription.id
      end
      it { is_expected.to set_flash[:error].now }
      it { is_expected.to render_template :edit }
    end
  end

  describe '#update' do
    let(:original_user) {create :user }
    let(:subscription) { create :subscription, user: original_user }
    let(:new_shirt_size) { 'W S' }
    let(:new_nickname) { '#update nickname' }
    let(:subscription_params) {{ user_id: subscription.user.id.to_s, shirt_size: new_shirt_size, name: new_nickname }}
    let(:valid_params) {{ id: subscription.id, subscription: subscription_params }}
    before { request.env["HTTP_REFERER"] = 'https://test.hostback' }

    it { expect { put :update, valid_params }.to change { subscription.reload.shirt_size }.to(new_shirt_size) }
    it { expect { put :update, valid_params }.to change { subscription.reload.name }.to(new_nickname) }
    it { put :update, valid_params; is_expected.not_to set_flash[:error] }
    it { put :update, valid_params; is_expected.to set_flash[:success] }
    it { put :update, valid_params; is_expected.to redirect_to :back }

    describe 'change billing date' do
      let(:new_billing_date) { subscription.next_assessment_at + 2.weeks }
      let(:date_params) { { id: subscription.id,
                            subscription: {
                              shirt_size: subscription.shirt_size,
                              name: subscription.name,
                              next_assessment_at: new_billing_date.to_date } } }
      it do
        expect_any_instance_of(Subscription).to receive(:readjust_rebilling_date)
        put :update, date_params
        expect(subscription.reload.next_assessment_at.to_date).to eq(new_billing_date.to_date)
      end
    end

    describe 'dont change user' do
      it 'doesnt call change_user' do
        expect(Subscription::UserChanger).not_to receive(:new)
        put :update, valid_params
      end

      it 'doest change the user' do
        expect { put :update, valid_params }.not_to change { subscription.reload.user }
      end
    end

    describe 'change user' do
      let(:new_user) { create :batman }
      let(:subscription_params) {{ user_id: new_user.id.to_s, shirt_size: new_shirt_size, name: new_nickname }}
      let(:recurly_account_service) { instance_spy RecurlyAdapter::AccountService }
      before do
        expect(RecurlyAdapter::AccountService).to receive(:new).with(subscription.recurly_account_id) { recurly_account_service }
        expect(recurly_account_service).to receive(:update).with(email: new_user.email)
      end

      it 'subscription is found in new user subscriptions' do
        put :update, valid_params
        expect(new_user.subscriptions).to include(subscription)
      end

      it 'subscription is not found in original user subscriptions' do
        put :update, valid_params
        expect(original_user.subscriptions).not_to include(subscription)
      end

      it { expect{ put :update, valid_params }.to change{ new_user.subscriptions.count }.by(1) }
      it { expect{ put :update, valid_params }.to change{ original_user.subscriptions.count }.by(-1) }
      it { put :update, valid_params; is_expected.not_to set_flash[:error] }
      it { put :update, valid_params; is_expected.to set_flash[:success] }
      it { put :update, valid_params; is_expected.to redirect_to :back }
    end
  end
end
