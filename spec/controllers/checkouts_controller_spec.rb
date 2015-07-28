require 'spec_helper'

describe CheckoutsController do
  include_context 'login_user'
  include_context 'force_ssl'

  describe '#create' do
    let(:plan) { create(:plan) }
    let(:legacy_plan) { create(:plan, :legacy_1_month) }

    context "logged in" do
      let(:recurly_sub) do 
        double('recurly_sub', account: '1', uuid: '1', account_code: '1')
      end
      let(:sub) do
        double('sub', id: '1', plan: plan, recurly_account_id: 'account_id_1',
               recurly_subscription_id: 'sub_id_1')
      end

      before do
        allow(AnalyticsWorkers::TrackSubscriptionPurchase).to receive(:perform_async)
        allow_any_instance_of(Rails.configuration.subscription_creation_service).
          to receive(:create_subscription).and_return(recurly_sub)
      end

      it 'redirects to payment completion page' do
        post :create, checkout: checkout_params, plan: plan.name
        expect(response).to redirect_to %r(/payment_completed/)
      end

      it 'saves UTM' do
        request.cookies[:lc_utm] = { 'utm_campaign' => "test" }.to_json

        expect { post :create, checkout: checkout_params, plan: plan.name }.to change(CampaignConversion, :count)
        expect(CampaignConversion.last.utm_campaign).to eq('test')
      end

      it 'redirects back if it is a legacy plan' do
        request.env["HTTP_REFERER"] = "where_i_came_from"

        post :create, checkout: checkout_params, plan: legacy_plan.name
        expect(response).to redirect_to "where_i_came_from"
      end
    end

    context 'with invalid params' do
      it 'does not create a subscription' do
        VCR.use_cassette 'subscription/chargify/create_1_month_failure',
          match_requests_on: [:method, :uri_ignoring_id] do
            expect{post :create, checkout: invalid_checkout_params, plan: plan.name }.to_not change(Subscription, :count)
        end
      end # it

      it "re-renders the :new template" do
        VCR.use_cassette 'subscription/chargify/create_1_month_failure',
          match_requests_on: [:method, :uri_ignoring_id] do
            post :create, checkout: invalid_checkout_params, plan: plan.name
        end
        expect(response).to render_template :new
      end

      it 'populates the error' do
        VCR.use_cassette 'subscription/chargify/create_1_month_failure',
          match_requests_on: [:method, :uri_ignoring_id] do
            post :create, checkout: invalid_checkout_params, plan: plan.name
        end
        expect(request.flash[:error]).to be_present
      end
    end # context
  end

  def checkout_params
    {
      looter_name: "Jeffects Testcase",
      shirt_size: "M XL",
      shipping_address_first_name: "Jeffrey",
      shipping_address_last_name: "Leung",
      shipping_address_line_1: "3401 Pasadena Ave",
      shipping_address_line_2: "",
      shipping_address_city: "Los Angeles",
      shipping_address_zip: "90012",
      shipping_address_country: "US",
      shipping_address_state: "CA",
      credit_card_number: "4111111111111111",
      "credit_card_expiration_date(3i)" => Date.tomorrow.day,
      "credit_card_expiration_date(2i)" => Date.tomorrow.month,
      "credit_card_expiration_date(1i)" => Date.tomorrow.year,
      credit_card_cvv: "123",
      billing_address_full_name: "Test Case",
      billing_address_line_1: "3401 Pasadena Ave",
      billing_address_line_2: "",
      billing_address_city: "Los Angeles",
      billing_address_zip: "90012",
      billing_address_country: "US",
      billing_address_state: "CA",
    }
  end

  def invalid_checkout_params
    invalid_checkout_params = checkout_params
    invalid_checkout_params['credit_card_expiration_date(1i)'] = Date.today - 1.year
    invalid_checkout_params
  end

end
