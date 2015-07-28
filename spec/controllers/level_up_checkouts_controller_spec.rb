RSpec.describe LevelUp::CheckoutsController do
  include_context 'login_user'
  include_context 'force_ssl'

  let(:sock_plan) { create(:sock_plan) }
  let(:sub) { create(:subscription) }


  describe "GET #new" do
    before do
      @user.subscriptions << sub
    end
    it "assigns @checkout" do
      get :new, plan: sock_plan.name

      expect( assigns :checkout ).to be_a Checkout
    end
    it "populates shirt size from query parameter" do
      get :new, plan: sock_plan.name, variant: "Unisex - L"

      expect(assigns(:checkout).shirt_size).to eq "Unisex - L"
    end
    it "defaults sock shirt_size to 'n/a'" do
      get :new, plan: sock_plan.name, variant: "All Sock Sizes"

      expect(assigns(:checkout).shirt_size).to eq "n/a"
    end
    it "defaults accessory shirt_size to 'n/a'" do
      get :new, plan: sock_plan.name, variant: "All Accessory Sizes"

      expect(assigns(:checkout).shirt_size).to eq "n/a"
    end
    it "defaults shipping address to the one associated with the users first active subscription" do
      get :new, plan: sock_plan.name

      expect(assigns(:checkout).shipping_address_line_1).to eq sub.shipping_address.line_1
      expect(assigns(:checkout).shipping_address_line_2).to eq sub.shipping_address.line_2
      expect(assigns(:checkout).shipping_address_city).to eq sub.shipping_address.city
      expect(assigns(:checkout).shipping_address_state).to eq sub.shipping_address.state
      expect(assigns(:checkout).shipping_address_zip).to eq sub.shipping_address.zip
      expect(assigns(:checkout).shipping_address_country).to eq sub.shipping_address.country
    end
    it "renders the new template if user is logged in and has an active subscription" do
      get :new, plan: sock_plan.name

      expect(response).to render_template(:new)
    end
    it "redirects to level_up page if user is not logged in" do
      sign_out(@user)
      get :new, plan: sock_plan.name

      expect(response).to redirect_to level_up_path
    end
    it "redirects to level_up page if user is logged in but has no active subscriptions" do
      @user.subscriptions.destroy_all
      get :new, plan: sock_plan.name

      expect(response).to redirect_to level_up_path
    end
  end

  describe "POST #create" do
    let(:subscription) { create(:subscription, plan: sock_plan) }
    before do
      allow_any_instance_of(Checkout).to receive_messages(
        :fulfill => nil,
        :created_subscription => subscription
      )
    end

    it "calls @checkout#fulfill" do
      expect_any_instance_of(Checkout).to receive(:fulfill)
      
      post :create, plan: sock_plan.name, checkout: checkout_params, variant_id: 1, variant_name: 'XL'
    end

    context "when checkout saves successfully" do
      before do
        allow(SubscriptionWorkers::DecrementInventory).to receive(:perform_async) { true }
        post :create, plan: sock_plan.name, checkout: checkout_params
      end

      it "assigns @subscription" do
        expect(assigns :subscription).to eq subscription
      end

      it "redirects to payment completed page" do
        expect(response).to redirect_to success_url
      end

      it "updates inventory counts" do
        expect(SubscriptionWorkers::DecrementInventory).to have_received(:perform_async).with(checkout_params[:variant_id])
      end
    end

    context "when checkout fails" do
      let(:checkout) { build(:checkout) }
      before do
        checkout.errors.add(:test_key, "test_error")
        allow_any_instance_of(Checkout).to receive(:errors).and_return checkout.errors
        post :create, plan: sock_plan.name, checkout: checkout_params
      end

      it{ is_expected.to set_flash[:error].now }
      it{ is_expected.to render_template :new }
    end
  end

  def checkout_params
    {
      looter_name: "Jeffects Testcase",
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

  def success_url
    payment_completed_path(
      checkout: assigns(:checkout),
      id: subscription.recurly_account_id,
      sid: subscription.recurly_subscription_id,
      rev: assigns(:checkout).total,
      tax: assigns(:checkout).tax_charges_after_discount,
      pid: assigns(:checkout).plan.id
    )
  end
end
