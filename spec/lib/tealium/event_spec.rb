require 'spec_helper'
module Tealium
  describe Event do
    describe '#convertro_event_type' do
      let!(:plan_1_month) { create(:plan) }
      let!(:plan_3_months) { create(:plan_3_months) }
      let!(:plan_6_months) { create(:plan_6_months) }
      let!(:subscriber) { create(:user) }

      context 'new subscription' do
        context 'successful creation' do
          it 'returns correct convertro event type for new user' do
            subscription = create(:subscription, plan: plan_3_months, user: subscriber)
            tealium_event = Tealium::Event.new(
              user: subscriber,
              subscription: subscription,
              event_type: :new_subscription_creation_success
            )
            expect(tealium_event.convertro_event_type).to eq("new.transaction-3mo")
          end

          it 'returns correct convertro event type for 1 month' do
            subscription = create(:subscription, plan: plan_1_month, user: subscriber)
            tealium_event = Tealium::Event.new(
              user: subscriber,
              subscription: subscription,
              event_type: :new_subscription_creation_success
            )
            expect(tealium_event.convertro_event_type).to eq("new.transaction-1mo")
          end

          it 'returns correct type for 6 month sub' do
            subscription = create(:subscription, plan: plan_6_months, user: subscriber)
            tealium_event = Tealium::Event.new(
              user: subscriber,
              subscription: subscription,
              event_type: :new_subscription_creation_success
            )
            expect(tealium_event.convertro_event_type).to eq("new.transaction-6mo")
          end
        end
      end

      context 'repeat subscription' do
        let!(:plan) { create(:plan_3_months) }
        let!(:subscriber) { create(:user_with_one_subscription) }

        it 'returns correct convertro event type for 1 month sub' do
          new_subscription = create(:subscription, plan: plan_1_month, user: subscriber)
          tealium_event = Tealium::Event.new(
            user: subscriber,
            subscription: new_subscription,
            event_type: :new_subscription_creation_success
          )
          expect(tealium_event.convertro_event_type).to eq("repeat.transaction-1mo")
        end

        it 'returns correct convertro event type for 3 months sub' do
          new_subscription = create(:subscription, plan: plan_3_months, user: subscriber)
          tealium_event = Tealium::Event.new(
            user: subscriber,
            subscription: new_subscription,
            event_type: :new_subscription_creation_success
          )
          expect(tealium_event.convertro_event_type).to eq("repeat.transaction-3mo")
        end

        it 'returns correct type for 6 month sub' do
          new_subscription = create(:subscription, plan: plan_6_months, user: subscriber)
          tealium_event = Tealium::Event.new(
            user: subscriber,
            subscription: new_subscription,
            event_type: :new_subscription_creation_success
          )
          expect(tealium_event.convertro_event_type).to eq("repeat.transaction-6mo")
        end
      end
    end
  end
end