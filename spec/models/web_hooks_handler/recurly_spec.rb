require 'spec_helper'

RSpec.describe WebHooksHandler::Recurly do
  it "has a list of allowed events" do
    allowed_events = [
                       'expired_subscription_notification',
                       'renewed_subscription_notification',
                       'updated_subscription_notification',
                       'canceled_subscription_notification',
                       'reactivated_account_notification',
                       'past_due_invoice_notification',
                       'successful_payment_notification',
                       'billing_info_updated_notification',
                       'canceled_account_notification',
                       'closed_invoice_notification',
                       'failed_payment_notification',
                       'new_account_notification',
                       'new_invoice_notification',
                       'new_subscription_notification',
                       'successful_refund_notification',
                       'void_payment_notification'
                     ]

    expect(WebHooksHandler::Recurly::EVENTS).to match_array allowed_events
  end

  describe "#handle" do
    let(:payload) do
      {
        "notification" => {
          "account" => {
            "account_code" => '100'
          },
          "subscription" => {
            "plan" => {
              "plan_code" => '1-month-subscription'
            },
            "uuid" => '1a'
          }
        }
      }
    end

    let(:handler) { WebHooksHandler::Recurly.new(payload.to_xml.gsub(/<\/?hash>/, '')) }

    context "on receiving an expired subscription notification" do
      let!(:subscription) do
        create(:subscription,
          subscription_status: 'active',
          recurly_subscription_id: '1a',
          subscription_periods: [build(:active_subscription_period)]
        )
      end

      before do
        payload['notification']['subscription']['state'] = 'expired'
        payload['expired_subscription_notification'] = payload.delete('notification') 

        handler.handle
      end
      after { SubscriptionWorkers::EmailListStatusUpdater.jobs.clear }

      it "changes subscription's status to canceled" do
        subscription.reload

        expect(subscription.subscription_status).to eq 'expired'
      end

      it "updates email list" do
        expect(SubscriptionWorkers::EmailListStatusUpdater.jobs.size).to eq 1
      end

      it "creates an expired version", versioning: true do
        subscription.reload

        version = subscription.versions.last

        expect(version.event).to eq 'expired'
      end
    end

    context "on receiving a renewed subscription notification" do
      let!(:subscription) do
        create(:subscription,
          subscription_status: 'active',
          recurly_subscription_id: '1a',
          subscription_periods: [build(:active_subscription_period)]
        )
      end

      it "handles renewal for subscription period" do
        payload['renewed_subscription_notification'] = payload.delete('notification') 

        expect_any_instance_of(SubscriptionPeriod::Handler).to receive(:handle_subscription_renewed)

        handler.handle
      end
    end

    context "on receiving an updated subscription notification" do
      let!(:subscription) do
        create(:subscription,
          subscription_status: 'active',
          recurly_subscription_id: '1a',
          subscription_periods: [build(:active_subscription_period)]
        )
      end
      let!(:recurly_subscription) { double('subscription_data') }
      let!(:plan_6_months) { FactoryGirl.create(:plan_6_months) }

      it "updates a subscription's next assessment at if it's different" do
        new_date = DateTime.now + 3.month
        payload['notification']['subscription']['current_period_ends_at'] = new_date
        payload['updated_subscription_notification'] = payload.delete('notification')
        allow_any_instance_of(RecurlyAdapter::SubscriptionDataRetriever).to receive(:subscription).and_return(recurly_subscription)
        allow(recurly_subscription).to receive(:pending_subscription).and_return(nil)

        handler.handle
        subscription.reload

        expect(subscription.next_assessment_at.to_i).to eq new_date.to_i
      end

      it "updates a subscription's plan if it's different" do
        create(:plan_3_months, name: '3-month-subscription')
        payload['notification']['subscription']['plan']['plan_code'] = '3-month-subscription'
        payload['updated_subscription_notification'] = payload.delete('notification')
        allow_any_instance_of(RecurlyAdapter::SubscriptionDataRetriever).to receive(:subscription).and_return(recurly_subscription)
        allow(recurly_subscription).to receive(:pending_subscription).and_return(nil) 

        handler.handle
        subscription.reload

        expect(subscription.plan_name).to eq '3-month-subscription'
      end

      it "updates subscription's next assessment with pending subscription in Recurly" do
        new_date = DateTime.now + 3.month
        payload['notification']['subscription']['current_period_ends_at'] = new_date
        payload['updated_subscription_notification'] = payload.delete('notification')
        allow_any_instance_of(RecurlyAdapter::SubscriptionDataRetriever).to receive(:subscription).and_return(recurly_subscription)
        allow(recurly_subscription).to receive(:pending_subscription).and_return(true)
        allow_any_instance_of(RecurlyAdapter::SubscriptionDataRetriever).to receive(:subscription).and_return(recurly_subscription)
        allow(recurly_subscription).to receive(:pending_subscription).and_return(recurly_subscription)
        allow(recurly_subscription).to receive(:plan_code).and_return('6-month-subscription')

        handler.handle
        subscription.reload

        expect(subscription.next_assessment_at.to_i).to eq new_date.to_i
      end

      it "updates subscription's plan to pending subscription in Recurly" do
        create(:plan_3_months, name: '3-month-subscription')
        payload['notification']['subscription']['plan']['plan_code'] = '3-month-subscription'
        payload['updated_subscription_notification'] = payload.delete('notification')
        allow_any_instance_of(RecurlyAdapter::SubscriptionDataRetriever).to receive(:subscription).and_return(recurly_subscription)
        allow(recurly_subscription).to receive(:pending_subscription).and_return(recurly_subscription)
        allow(recurly_subscription).to receive(:plan_code).and_return('6-month-subscription')

        handler.handle
        subscription.reload

        expect(subscription.plan_name).to eq '6-month-subscription'
      end
    end

    context "on receiving a canceled subscription notification" do
      let!(:subscription) do
        create(:subscription,
          subscription_status: 'active',
          recurly_subscription_id: '1a',
          subscription_periods: [build(:active_subscription_period)]
        )
      end

      before do
        payload['canceled_subscription_notification'] = payload.delete('notification') 

        handler.handle
      end

      after do
        SubscriptionWorkers::CancellationEmail.jobs.clear
        SubscriptionWorkers::EmailListStatusUpdater.jobs.clear
      end
      
      it "updates subscription's cancel at end of period flag to true" do
        subscription.reload

        expect(subscription.cancel_at_end_of_period).to be true
      end

      it "sends user an email confirmation" do
        expect(SubscriptionWorkers::CancellationEmail.jobs.size).to eq 1
      end

      it "updates email list" do
        expect(SubscriptionWorkers::EmailListStatusUpdater.jobs.size).to eq 1
      end

      it "creates a canceled version", versioning: true do
        subscription.reload

        version = subscription.versions.last

        expect(version.event).to eq 'initiated pending cancellation'
      end
    end

    context "on receiving a reactivated subscription notification" do
      let!(:subscription) do
        create(:subscription,
          subscription_status: 'active',
          cancel_at_end_of_period: true,
          recurly_subscription_id: '1a',
          subscription_periods: [build(:active_subscription_period)]
        )
      end

      before do
        payload['reactivated_account_notification'] = payload.delete('notification') 

        handler.handle
      end

      after do
        SubscriptionWorkers::RemoveCancellationEmail.jobs.clear
        SubscriptionWorkers::EmailListStatusUpdater.jobs.clear
      end
      
      it "updates subscription's cancel at end of period flag to nil" do
        subscription.reload

        expect(subscription.cancel_at_end_of_period).to be nil
      end

      it "sends user an email confirmation" do
        expect(SubscriptionWorkers::RemoveCancellationEmail.jobs.size).to eq 1
      end

      it "updates email list" do
        expect(SubscriptionWorkers::EmailListStatusUpdater.jobs.size).to eq 1
      end

      it "creates a reactivated version", versioning: true do
        subscription.reload

        version = subscription.versions.last

        expect(version.event).to eq 'removed pending cancellation'
      end
    end

    context "on receiving a past due invoice notification" do
      let!(:subscription) do
        create(:subscription,
          subscription_status: 'active',
          recurly_subscription_id: '1a',
          subscription_periods: [build(:active_subscription_period)]
        )
      end

      context "when there is a subscription id in the payload" do
        it "updates subscription and current_period's status to 'past_due'" do
          payload['notification'].merge!('invoice' => {'subscription_id' => '1a'})
          payload['past_due_invoice_notification'] = payload.delete('notification') 

          handler.handle
          subscription.reload

          expect(subscription.subscription_status).to eq 'past_due'
          expect(subscription.current_period.status).to eq 'past_due'
        end
      end
    end

    context "on receive a successful payment notification" do
      context "and subscription is in dunning" do
        let!(:subscription) do
          create(:subscription,
            subscription_status: 'past_due',
            recurly_subscription_id: '1a',
            subscription_periods: [build(:dunning_subscription_period)]
          )
        end

        it "updates subscription and current_period's status to 'active'" do
          payload['notification'].merge!('transaction' => {'subscription_id' => '1a'})
          payload['successful_payment_notification'] = payload.delete('notification')
          
          handler.handle
          subscription.reload

          expect(subscription.subscription_status).to eq 'active'
          expect(subscription.current_period.status).to eq 'active'
        end
      end
    end
  end
end