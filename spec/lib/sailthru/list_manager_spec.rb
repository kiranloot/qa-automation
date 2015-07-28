require 'spec_helper'

describe Sailthru::ListManager do
  let(:user) { create(:user) }
  let(:list_manager) { Sailthru::ListManager.new user }

  subject { list_manager }

  describe '#initialize' do
    it 'sets @user to user' do
      expect(list_manager.instance_variable_get(:@user)).to eq user
    end

    it 'sets @email to user.email' do
      expect(list_manager.instance_variable_get(:@email)).to eq user.email
    end
  end

  describe "#subscribe_new_account" do
    before do
      @lists = {'lootcrate' => 1}
      @vars = {
        'USER_ID' => user.id,
        'subscription_status' => 'not_subscribed'
      }
      @data = {
        'id' => user.email,
        'key' => 'email',
        'lists' => @lists,
        'vars' => @vars
      }
    end

    it 'subscribe adds user to a list' do
      expect_any_instance_of(Sailthru::Client).to receive(:api_post)
      VCR.use_cassette 'sailthru/subscribe_new_account_success', match_requests_on: [:method, :uri_ignoring_id] do
        list_manager.subscribe_new_account
      end
      vars = list_manager.instance_variable_get(:@vars)
      expect(vars[:customer_number]).to eq user.id
    end

    it "sets subscription_status to 'not_subscribed'" do
      expect_any_instance_of(Sailthru::Client).to receive(:api_post)
      VCR.use_cassette 'sailthru/subscribe_new_account_success', match_requests_on: [:method, :uri_ignoring_id] do
        list_manager.subscribe_new_account
      end
      vars = list_manager.instance_variable_get(:@vars)
      expect(vars[:subscription_status]).to eq 'not_subscribed'
    end

    describe "#update_subscription_status" do

      context "when user have an active subscription" do
        let!(:subscription) { create(:subscription, user: user, subscription_status: 'active') }
        it "updates subscription_status to active" do
          VCR.use_cassette 'sailthru/update_subscription_status_success', match_requests_on: [:method, :uri_ignoring_id] do
            list_manager.update_subscription_status

            vars = list_manager.instance_variable_get(:@vars)
            expect(vars[:subscription_status]).to eq 'active'
          end
        end
      end

      context "when user has no active subscription" do
        let!(:subscription) { create(:subscription, user: user, subscription_status: 'canceled') }
        it 'updates subscription_status to canceled' do
          VCR.use_cassette 'sailthru/update_subscription_status_success', match_requests_on: [:method, :uri_ignoring_id] do
            list_manager.update_subscription_status

            vars = list_manager.instance_variable_get(:@vars)
            expect(vars[:subscription_status]).to eq 'canceled'
          end
        end
      end

      context "no subscriptions" do
        it 'updates subscription_status to canceled' do
          VCR.use_cassette 'sailthru/update_subscription_status_success', match_requests_on: [:method, :uri_ignoring_id] do
            list_manager.update_subscription_status

            vars = list_manager.instance_variable_get(:@vars)
            expect(user.subscriptions.present?).to be false
            expect(vars[:subscription_status]).to eq 'canceled'
          end
        end
      end

      context "when user have a subscription set to cancel_at_end_of_period" do
        it "updates subscription_status to canceled" do
          VCR.use_cassette 'sailthru/update_subscription_status_success', match_requests_on: [:method, :uri_ignoring_id] do
            list_manager.update_subscription_status

            vars = list_manager.instance_variable_get(:@vars)
            expect(vars[:subscription_status]).to eq 'canceled'
          end
        end
      end
    end

    describe "#update_new_subscription" do
      context "new subscriber" do
        let!(:subscription) { create(:subscription, user: user) }
        before do
            expect_any_instance_of(Sailthru::Client).to receive(:api_post)
            @response   = list_manager.update_new_subscription
            @vars = list_manager.instance_variable_get(:@vars)
        end

        it "update shirt_size" do
          expect(@vars[:shirt_size]).to eq subscription.shirt_size
        end

        it 'updates all shipping address fields' do
          expect(@vars[:shipping_address]).to eq subscription.shipping_address.line_1
          expect(@vars[:shipping_address_2]).to eq subscription.shipping_address.line_2
          expect(@vars[:shipping_city]).to eq subscription.shipping_address.city
          expect(@vars[:shipping_state]).to eq subscription.shipping_address.state
          expect(@vars[:shipping_postal_code]).to eq subscription.shipping_address.zip
          expect(@vars[:shipping_country]).to eq subscription.shipping_address.country
          expect(@vars[:first_name]).to eq subscription.shipping_address.first_name
          expect(@vars[:last_name]).to eq subscription.shipping_address.last_name
        end

        it "updates period" do
          expect(@vars[:subscription_length]).to eq subscription.plan.period
        end

        it "updates subscription_status" do
          expect(@vars[:subscription_status]).to eq subscription.subscription_status
        end

      end
    end

  end

end
