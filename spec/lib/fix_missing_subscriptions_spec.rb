require 'spec_helper'

describe FixMissingSubscriptions do
  let(:fixer) { FixMissingSubscriptions.new }
  let(:csv_file) { Rack::Test::UploadedFile.new('spec/support/missing_subs.csv', 'text/csv') }

  describe "#fix(csv_file)" do
    it "creates subscriptions" do
      expect(fixer).to receive(:create_subscription_for).exactly(5).times

      fixer.fix(csv_file)
    end
  end

  describe "#chargify_sub_ids_array(csv_file)" do
    # It should return an array of chargify subscription ids that are not tied to a subscription in lootcrate's database.
    context "when csv_file contains existing chargify subscription ids" do
      let!(:subscription) { create(:subscription, chargify_subscription_id: 7452152) }
      let!(:nonbraintree_subscription) { create(:subscription, chargify_subscription_id: 7452152, braintree: nil) }

      it "removes the ids from the array" do
        result = fixer.chargify_sub_ids_array(csv_file)

        expect(result).to_not include subscription.chargify_subscription_id
        expect(result).to_not include nonbraintree_subscription.chargify_subscription_id
      end
    end
  end

  describe "#convert_csv(file)" do
    it "converts csv to an array of hashes with proper keys" do
      result = fixer.convert_csv (csv_file)

      expect(result.first).to have_key(:chargify_subscription_id)
      expect(result.first).to have_key(:nonbraintree_chargify_subscription_id)
    end
  end

  describe "#create_subscription_for(chargify_sub_id, braintree = nil)" do
    let!(:user) { create(:user, email: 'jeffects201501071634@mailinator.com') }
    let!(:plan) { create(:plan) }

    it "creates a valid subscription" do
      VCR.use_cassette 'fix_missing_subscriptions/subscription', match_requests_on: [:method, :uri_ignoring_id] do
        subscription = fixer.create_subscription_for 7452122, true

        expect(subscription.shipping_address).to_not be_nil
        expect(subscription.billing_address).to_not be_nil
        expect(subscription.plan).to_not be_nil
        expect(user.chargify_customer_accounts).to_not be_empty
        expect(subscription.last_4).to eq '1'
        expect(subscription.next_assessment_at).to_not be_nil
      end
    end

    it "creates a subscription period" do
      VCR.use_cassette 'fix_missing_subscriptions/subscription', match_requests_on: [:method, :uri_ignoring_id] do
        expect_any_instance_of(SubscriptionPeriod::Handler).to receive(:handle_subscription_created)

        subscription = fixer.create_subscription_for 7452122, true
      end
    end

    context "when braintree is true" do
      it "uses braintree domain" do
        VCR.use_cassette 'fix_missing_subscriptions/subscription', match_requests_on: [:method, :uri_ignoring_id] do
          # set_chargify_site_to_braintree
          expect(ChargifySwapper).to receive(:set_chargify_site_to_braintree)

          fixer.create_subscription_for 7452122, true
        end
      end

      it "creates braintree sub and customer" do
        VCR.use_cassette 'fix_missing_subscriptions/subscription', match_requests_on: [:method, :uri_ignoring_id] do
          fixer.create_subscription_for 7452122, true
          subscription = Subscription.last
          customer     = ChargifyCustomer.last

          expect(subscription.braintree).to eq true
          expect(customer.braintree).to eq true
        end
      end
    end

    context "when braintree is nil" do
      it "uses authorize domain" do
        VCR.use_cassette 'fix_missing_subscriptions/nonbraintree_subscription', match_requests_on: [:method, :uri_ignoring_id] do
            expect(ChargifySwapper).to receive(:set_chargify_site_to_authorize)

            fixer.create_subscription_for 6567534
        end
      end

      it "creates nonbraintree_subscription and customer" do
        VCR.use_cassette 'fix_missing_subscriptions/nonbraintree_subscription', match_requests_on: [:method, :uri_ignoring_id] do
          create(:user, email: 'email58@purp.com')
          fixer.create_subscription_for 6567534
          subscription = Subscription.last
          customer     = ChargifyCustomer.last

          expect(subscription.braintree).to eq nil
          expect(customer.braintree).to eq nil
        end
      end
    end

    context "when it fails" do
      let!(:user) { create(:user, email: 'jeffects201501071634@mailinator.com') }
      let!(:plan) { create(:plan, name: 'jibberish') }

      it "does not create any records" do
        VCR.use_cassette 'fix_missing_subscriptions/subscription', match_requests_on: [:method, :uri_ignoring_id], allow_playback_repeats: true do
          expect{
            fixer.create_subscription_for 7452122, true
          }.to_not change(Subscription, :count)

          expect{
            fixer.create_subscription_for 7452122, true
          }.to_not change(ShippingAddress, :count)

          expect{
            fixer.create_subscription_for 7452122, true
          }.to_not change(BillingAddress, :count)

          expect{
            fixer.create_subscription_for 7452122, true
          }.to_not change(ChargifyCustomer, :count)
        end
      end
    end
  end
end