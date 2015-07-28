require 'spec_helper'

describe MailChimp::ListManager do
  let(:list_manager) { MailChimp::ListManager.new user }
  let(:user) { create(:user, email: 'hai.nguyen+d1@lootcrate.com') }
  subject { list_manager }

  describe "#initialize" do
    it "sets @user to user" do
      expect(list_manager.instance_variable_get(:@user)).to eq user
    end

    it "sets @email to user.email" do
      expect(list_manager.instance_variable_get(:@email)).to eq user.email
    end

    it "sets @double_optin to false" do
      expect(list_manager.instance_variable_get(:@double_optin)).to eq false
    end

    it "sets @update_existing to false" do
      expect(list_manager.instance_variable_get(:@update_existing)).to eq false
    end
  end

  describe "#subscribe_new_account" do
    # TODO: Weird bug where subscribe_new_account gets called twice. Can't seem to figure it out.
    # it "returns the subscriber's email" do
    #   VCR.use_cassette 'mail_chimp/subscribe_new_account_success', match_requests_on: [:method, :uri_ignoring_id] do
    #     list_manager.subscribe_new_account

    #     expect(response['email']).to eq user.email
    #   end
    # end

    it "sets SUB_STATUS to 'not_subscribed" do
      VCR.use_cassette 'mail_chimp/subscribe_new_account_success', match_requests_on: [:method, :uri_ignoring_id] do
        list_manager.subscribe_new_account

        merge_vars = list_manager.instance_variable_get(:@merge_vars)
        expect(merge_vars[:SUB_STATUS]).to eq 'not_subscribed'
      end
    end
  end

  describe "#update_subscription_status" do
    let!(:subscription) { create(:subscription, user: user, subscription_status: 'active') }

    it "sets @update_existing to true" do
      VCR.use_cassette 'mail_chimp/update_subscription_status_success', match_requests_on: [:method, :uri_ignoring_id] do
        list_manager.update_subscription_status

        update_existing = list_manager.instance_variable_get(:@update_existing)
        expect(update_existing).to eq true
      end
    end

    context "when user have an active subscription" do
      it "updates SUB_STATUS to active" do
        VCR.use_cassette 'mail_chimp/update_subscription_status_success', match_requests_on: [:method, :uri_ignoring_id] do
          list_manager.update_subscription_status

          merge_vars = list_manager.instance_variable_get(:@merge_vars)
          expect(merge_vars[:SUB_STATUS]).to eq 'active'
        end
      end

      context "and a canceled subscription" do
        before do
          user.subscriptions << create(:subscription, subscription_status: 'canceled')
          user.save
        end

        it "updates SUB_STATUS to active" do
          VCR.use_cassette 'mail_chimp/update_subscription_status_success', match_requests_on: [:method, :uri_ignoring_id] do
            list_manager.update_subscription_status

            merge_vars = list_manager.instance_variable_get(:@merge_vars)
            expect(merge_vars[:SUB_STATUS]).to eq 'active'
          end
        end
      end
    end

    context "when user does not have an active subscription" do
      before do
        subscription.subscription_status = 'canceled'
        subscription.save
      end

      it "updates SUB_STATUS to canceled" do
        VCR.use_cassette 'mail_chimp/update_subscription_status_success', match_requests_on: [:method, :uri_ignoring_id] do
          list_manager.update_subscription_status

          merge_vars = list_manager.instance_variable_get(:@merge_vars)
          expect(merge_vars[:SUB_STATUS]).to eq 'canceled'
        end
      end
    end

    context "when user have a subscription set to cancel_at_end_of_period" do
      before do
        subscription.cancel_at_end_of_period = true
        subscription.save
      end

      it "updates SUB_STATUS to canceled" do
        VCR.use_cassette 'mail_chimp/update_subscription_status_success', match_requests_on: [:method, :uri_ignoring_id] do
          list_manager.update_subscription_status

          merge_vars = list_manager.instance_variable_get(:@merge_vars)
          expect(merge_vars[:SUB_STATUS]).to eq 'canceled'
        end
      end
    end

    context "when user does not have any subscriptions" do
      it "returns an empty hash" do
        user.subscriptions = []
        user.save
        response = list_manager.update_subscription_status

        expect(response).to be_empty
      end
    end
  end

  describe "#update_new_subscription" do
    context 'new subscriber' do
      let!(:subscription) { create(:subscription, user: user) }
      before do
        VCR.use_cassette 'mail_chimp/update_new_subscription_success', match_requests_on: [:method, :uri_ignoring_id] do
          @response   = list_manager.update_new_subscription
          @merge_vars = list_manager.instance_variable_get(:@merge_vars)
        end
      end

      it "updates SHIRT_SIZE" do
        expect(@merge_vars[:SHIRT_SIZE]).to eq subscription.shirt_size
      end

      it "updates COUNTRY" do
        expect(@merge_vars[:COUNTRY]).to eq subscription.plan.country
      end

      it "updates PERIOD" do
        expect(@merge_vars[:PERIOD]).to eq subscription.plan.period
      end

      it "updates PERIOD" do
        expect(@merge_vars[:SUB_STATUS]).to eq subscription.subscription_status
      end

      it "returns subscriber" do
        expect(@response['email']).to eq user.email
      end
    end

    context 'exceptions' do
      let!(:user) { create(:user, email: 'jeffects99999999@lootcrate.com') }
      let!(:subscription) { create(:subscription, user: user) }

      describe 'when user is unsubscribed from mailing list' do
        it "should not raise any errors" do
          VCR.use_cassette 'mail_chimp/update_user_but_is_unsubscribed_from_list', match_requests_on: [:method, :uri_ignoring_id] do
            expect{list_manager.update_new_subscription}.to_not raise_error
            expect(list_manager.update_new_subscription).to be_empty
          end
        end

        it "should not notify Airbrake" do
          VCR.use_cassette 'mail_chimp/update_user_but_is_unsubscribed_from_list', match_requests_on: [:method, :uri_ignoring_id] do
            expect{Airbrake}.to_not raise_error

            list_manager.update_new_subscription
          end
        end
      end

      describe 'when updating an non-existent email address' do
        it 'should not raise any errors' do
          VCR.use_cassette 'mail_chimp/update_non_existent_user_from_list', match_requests_on: [:method, :uri_ignoring_id] do
            expect{list_manager.update_new_subscription}.to_not raise_error
            expect(list_manager.update_new_subscription).to be_empty
          end
        end
      end
    end
  end
end
