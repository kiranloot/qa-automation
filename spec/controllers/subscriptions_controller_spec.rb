require 'spec_helper'

describe SubscriptionsController do
  include_context 'login_user'
  include_context 'force_ssl'

  describe "GET #upgrade_preview" do
    let!(:subscription) do
      create(:subscription,
        user: @user,
        subscription_periods: [build(:active_subscription_period)]
      )
    end

    context "when there are no upgradable_plans" do
      before do
        @upgradable_plans = []
        allow(PlanFinder).to receive(:upgradable_plans_for).and_return(@upgradable_plans)

        get :upgrade_preview, id: subscription.id
      end

      it { is_expected.to render_template(:upgrade_preview) }

      it "assigns @subscription" do
        expect(assigns(:subscription)).to eq subscription
      end

      it "assigns @upgradable_plans" do
        expect(assigns(:upgradable_plans)).to match_array @upgradable_plans
      end
    end

    context "when there are upgradable_plans" do
      let(:preview) do
        {
          charge_in_cents: 100,
          prorated_adjustment_in_cents: 100,
          payment_due_in_cents: 100
        }
      end

      before do
        @upgradable_plans = [create(:plan_3_months), create(:plan_6_months)]
        allow_any_instance_of(Subscription::Upgrader).to receive(:preview) { preview }
      end

      it "assigns @upgrade_preview" do
        get :upgrade_preview, id: subscription.id
        upgrade_preview = assigns(:upgrade_preview)

        expect(upgrade_preview.keys).to match_array preview.keys
      end

      it "assigns plan using last upgradable_plan name" do
        get :upgrade_preview, id: subscription.id

        expect(assigns(:plan)).to eq @upgradable_plans.last
      end

      context "and a selected product handle" do
        it "assigns selected product handle to plan" do
          get :upgrade_preview, id: subscription.id, selected_product: '6-month-subscription'

          expect(assigns(:plan).name).to eq '6-month-subscription'
        end
      end
    end
  end

  describe 'GET #index' do
    context 'changing the country' do
      before do
        get :index, country: 'DE'
      end

      it 'sets the country cookie' do
        expect(cookies[:country]).to eq 'DE'
      end

      it 'sets the locale' do
        expect(I18n.locale).to eq :de
      end
    end
  end

  describe "PUT #upgrade" do
    let!(:subscription) do
      create(:subscription,
        user: @user,
        subscription_periods: [build(:active_subscription_period)]
      )
    end
    let(:plan) { create(:plan_6_months) }

    context "when it upgrades successfully" do
      before do
        allow_any_instance_of(Subscription::Upgrader).to receive(:upgrade) { true }

        put :upgrade, id: subscription.id, upgrade_plan_name: plan.name
      end

      it "assigns @subscription" do
        expect(assigns(:subscription)).to eq subscription
      end

      it "assigns @plan" do
        expect(assigns(:plan)).to eq plan
      end

      it { is_expected.to set_flash[:notice] }
      it { is_expected.to redirect_to user_accounts_subscriptions_path }
    end

    context "when it fails to upgrade" do
      before do
        allow_any_instance_of(Subscription::Upgrader).to receive(:upgrade) { true }
        allow_any_instance_of(Subscription::Upgrader).to receive_message_chain(:errors, :any?) { true }

        put :upgrade, id: subscription.id, upgrade_plan_name: plan.name
      end

      it { is_expected.to set_flash[:error] }
      it { is_expected.to redirect_to user_accounts_subscriptions_path }
    end

    context "user overwrites with upgrade plan = subscription" do
      let(:plan) { create(:plan) }

      before do
        @subscription = subscription
        put :upgrade, id: subscription, plan: plan.name
      end

      it "does not perform upgrade" do
        expect{ put :upgrade, id: subscription, plan: plan.name }.not_to change{ subscription }
      end

      it "sets flash error" do
        expect(flash[:error]).to eq('Invalid upgrade option.  Please try again or contact customer support.')
      end

      it { is_expected.to redirect_to user_accounts_subscriptions_path }
    end

    context "user overwrites with upgrade plan < subscription" do
      let(:plan) { create(:plan) }
      let!(:subscription) do
        create(:subscription,
          user: @user,
          plan: (FactoryGirl.create(:plan_3_months))
        )
      end

      before do
        @subscription = subscription
        put :upgrade, id: subscription, plan: plan.name
      end

      it "does not perform upgrade" do
        expect{ put :upgrade, id: subscription, plan: plan.name }.not_to change{ subscription }
      end

      it "sets flash error" do
        expect(flash[:error]).to eq('Invalid upgrade option.  Please try again or contact customer support.')
      end

      it { is_expected.to redirect_to user_accounts_subscriptions_path }
    end
  end

  describe "PUT #skip_a_month" do
    let!(:subscription) do
      create(:subscription,
        user: @user,
        subscription_periods: [build(:active_subscription_period)]
      )
    end

    context "when it is successful" do
      before do
        request.env["HTTP_REFERER"] = 'https://test.hostback'
        allow_any_instance_of(Subscription::Skipper).to receive_message_chain(:errors, :presence) { false }
        allow_any_instance_of(Subscription::Skipper).to receive_message_chain(:skip_a_month) { true }

        get :skip_a_month, id: subscription.id
      end

      it "assigns @subscription" do
        expect(assigns(:subscription)).to eq subscription
      end

      it { is_expected.to redirect_to skip_a_month_success_subscription_path(subscription) }
      it { is_expected.to set_flash[:notice] }
    end

    context "when it fails" do
      before do
        request.env["HTTP_REFERER"] = 'https://test.hostback'
        errors = double('errors', full_messages: ['Error'])
        allow_any_instance_of(Subscription::Skipper).to receive_message_chain(:errors, :presence) { errors }
        allow_any_instance_of(Subscription::Skipper).to receive_message_chain(:skip_a_month) { false }

        get :skip_a_month, id: subscription.id
      end

      it { is_expected.to redirect_to :back }
      it { is_expected.to set_flash[:error] }
    end
  end

  describe "PUT #undo_cancellation_at_end_of_period" do
    let!(:subscription) do
      create(:subscription,
        user: @user,
        subscription_periods: [build(:active_subscription_period)]
      )
    end
    context 'when it reactivates' do
      let(:errors) { double('errors', presence: false) }
      let(:canceller) do
        instance_double(Subscription::Canceller,
                        errors: errors,
                        remove_cancel_at_end_of_period: true
                       )
      end

      before do
        request.env["HTTP_REFERER"] = 'https://test.hostback'
        allow(Subscription::Canceller).to receive(:new).and_return(canceller)

        put :undo_cancellation_at_end_of_period, id: subscription.id
      end

      it 'reactivates a subscription' do
        expect(canceller).to have_received(:remove_cancel_at_end_of_period)
      end

      it { is_expected.to redirect_to :back }
      it { is_expected.to set_flash[:notice] }
    end

    context 'when it fails to reactivates' do
      let(:errors) { double('errors', presence: true) }
      let(:canceller) do
        instance_double(Subscription::Canceller,
                        errors: errors,
                        remove_cancel_at_end_of_period: true
                       )
      end

      before do
        request.env["HTTP_REFERER"] = 'https://test.hostback'
        allow(Subscription::Canceller).to receive(:new).and_return(canceller)

        put :undo_cancellation_at_end_of_period, id: subscription.id
      end

      it 'reactivates a subscription' do
        expect(canceller).to have_received(:remove_cancel_at_end_of_period)
      end

      it { is_expected.to redirect_to :back }
      it { is_expected.to set_flash[:error] }
    end
  end

  describe "GET #cancellation" do
    let!(:subscription) do
      create(:subscription,
        user: @user,
        subscription_periods: [build(:active_subscription_period)]
      )
    end

    before do
      get :cancellation, id: subscription.id
    end

    it "renders the :cancellation template" do
      expect(response).to render_template(:cancellation)
    end

    it "assigns @subscription" do
      expect(assigns(:subscription)).to eq subscription
    end

    context "when subscription is pending cancellation" do
      before do
        subscription.cancel_at_end_of_period = true
        subscription.save
        get :cancellation, id: subscription.id
      end

      it { is_expected.to redirect_to user_accounts_subscriptions_path }
    end
  end

  describe "PUT #cancel_at_end_of_period" do
    let!(:subscription) do
      create(:subscription,
        user: @user,
        subscription_periods: [build(:active_subscription_period)]
      )
    end
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

      it { is_expected.to redirect_to user_accounts_subscriptions_path(survey: true) }

    end

    context "when it fails to cancel at end of period" do
      before do
        allow_any_instance_of(Subscription).to receive(:cancel_at_end_of_period).and_return(nil)
        request.env["HTTP_REFERER"] = 'https://test.hostback'
        
        put :cancel_at_end_of_period, id: subscription.id
      end

      it "assigns @subscription" do
        expect(assigns(:subscription)).to eq subscription
      end

      it { is_expected.to redirect_to :back }
      it { is_expected.to set_flash[:error] }
    end
  end

  describe "PUT #apply_coupon_for_reactivation" do
    let!(:subscription) do
      create(:subscription,
        user: @user,
        subscription_status: 'canceled',
        subscription_periods: [build(:active_subscription_period)]
      )
    end
    let(:params) do
      {
        id: subscription.id,
        coupon_code: '10PERCENT',
        format: :js
      }
    end

    before do
      VCR.use_cassette 'subscription/apply_coupon_success', match_requests_on: [:method, :uri_ignoring_id] do
        put :apply_coupon_for_reactivation, params
      end
    end

    it "assigns @subscription" do
      expect(assigns(:subscription)).to eq subscription
    end

    it "assigns @preview" do
      expect(assigns(:preview)).to_not be_nil
    end
  end

  describe "GET #reactivation" do
    let!(:subscription) do
      create(:subscription,
        user: @user,
        subscription_status: 'canceled',
        subscription_periods: [build(:active_subscription_period)]
      )
    end

    before do
      allow_any_instance_of(Subscription::Reactivator).to receive(:preview) { {} }
    end

    context "when subscription's status is NOT active" do
      before do
        get :reactivation, id: subscription.id
      end

      it "renders the :reactivate template" do
        expect(response).to render_template(:reactivation)
      end

      it "assigns @subscription" do
        expect(assigns(:subscription)).to eq subscription
      end

      it "assigns @preview" do
        expect(assigns(:preview)).to eq({})
      end
    end

    context "when subscription's status is active" do
      before do
        subscription.subscription_status = 'active'
        subscription.save

        get :reactivation, id: subscription.id
      end

      it { is_expected.to redirect_to user_accounts_subscriptions_path }

      it "does not assign @preview" do
        expect(assigns(:preview)).to_not eq({})
      end
    end
  end

  describe "PUT #reactivate" do
    let!(:subscription) do
      create(:subscription,
        user: @user,
        subscription_status: 'canceled',
        subscription_periods: [build(:active_subscription_period)]
      )
    end

    context "when it successfully reactivates" do
      before do
        allow_any_instance_of(Subscription::Reactivator).to receive(:reactivate) { true }
        allow_any_instance_of(Subscription::Reactivator).to receive_message_chain(:errors, :presence) { false }
        put :reactivate, id: subscription.id
      end

      it "assigns @subscription" do
        expect(assigns(:subscription)).to eq subscription
      end

      it { is_expected.to redirect_to user_accounts_subscriptions_path }
      it { is_expected.to set_flash[:notice] }

      context "with a coupon_code" do
        before do
          put :reactivate, id: subscription.id, coupon_code: '10PERCENT'
        end

        it { is_expected.to set_flash[:notice] }
      end
    end

    context "when it fails to reactivate" do
      before do
        allow_any_instance_of(Subscription::Reactivator).to receive(:reactivate) { false }
        error = double('error', full_messages: ['Error'])
        allow_any_instance_of(Subscription::Reactivator).to receive_message_chain(:errors, :presence) { error }
        put :reactivate, id: subscription.id
      end

      it "assigns @subscription" do
        expect(assigns(:subscription)).to eq subscription
      end

      it { is_expected.to redirect_to user_accounts_subscriptions_path }
      it { is_expected.to set_flash[:error] }
    end
  end

  describe "GET #edit" do
    let!(:subscription) do
      create(:subscription,
        user: @user,
        subscription_periods: [build(:active_subscription_period)]
      )
    end

    it 'assigns a user subscription as @subscription' do
      get :edit, id: subscription.id

      expect(assigns(:subscription)).to eq subscription
    end

    it 'renders the :edit template' do
      get :edit, id: subscription.id

      expect(response).to render_template :edit
    end
  end

  describe "PUT #update" do
    before :each do
      @subscription = create(:subscription, user: @user)
    end

    context "with valid params" do
      let(:sub_attributes) { attributes_for(:subscription) }

      it 'located the requested @subscription' do
        put :update, id: @subscription, subscription: sub_attributes

        expect(assigns(:subscription)).to eq(@subscription)
      end

      it "changes @subscription's attributes" do
        expect{
          put :update, id: @subscription, subscription: attributes_for(:subscription, shirt_size: "W L")
          @subscription.reload
        }.to change{@subscription.shirt_size}
      end

      it "redirects to the user_accounts page" do
        put :update, id: @subscription, subscription: sub_attributes

        expect(response).to redirect_to user_accounts_path
      end
    end

    describe "with invalid params" do
      let(:sub_attributes) { attributes_for(:invalid_subscription) }

      it "does not change the @subscription's attributes" do
        expect{
          put :update, id: @subscription, subscription: sub_attributes
          @subscription.reload
        }.to_not change{@subscription.shirt_size}
      end

      it "re-renders the edit method" do
        put :update, id: @subscription, subscription: sub_attributes

        expect(response).to render_template :edit
      end
    end
  end

  describe "PUT #update_summary" do
    let!(:plan) { create(:plan) }
    let(:coupon_code) { "10PERCENT" }
    let(:params) do
      {
        plan: plan.name,
        coupon_code: coupon_code,
        format: :js
      }
    end

    it "assigns @plan" do
      put :update_summary, params

      expect(assigns(:plan)).to eq plan
    end

    it "assigns @coupon_code" do
      put :update_summary, params

      expect(assigns(:coupon_code)).to eq coupon_code
    end

    it "calculates the summary" do
      expect(controller).to receive(:calculate_summary)

      put :update_summary, params
    end

    context "when unable to find a plan" do
      before do
        params[:plan] = nil
      end

      it "redirects to select a plan page" do
        put :update_summary, params

        expect(response).to redirect_to join_path
      end
    end

    context "when unable to find a valid coupon" do
      let(:coupon_code) { 'INVALID' }

      it "removes coupon_code from params" do
        put :update_summary, params

        expect(controller.params[:coupon_code]).to eq nil
      end
    end
  end
end
