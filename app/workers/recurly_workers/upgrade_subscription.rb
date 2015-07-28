module RecurlyWorkers
  class UpgradeSubscription
    include Sidekiq::Worker

    def perform(recurly_sub_uuid, upgraded_plan_name, next_assessment_at)
      begin
        recurly_subscription = Recurly::Subscription.find recurly_sub_uuid

        update_recurly_plan!(recurly_subscription, upgraded_plan_name)
        recurly_subscription.postpone(next_assessment_at)
      rescue Recurly::Resource::NotFound => e
        handle_error(e, recurly_sub_uuid)
      rescue => e
        original_plan_code = recurly_subscription.plan_code
        update_recurly_plan!(recurly_subscription, original_plan_code)
        handle_error(e, recurly_sub_uuid)
      end
    end

    private
      def update_recurly_plan!(sub, plan_code)
        sub.update_attributes!(
          timeframe: 'renewal',
          plan_code: plan_code
        )
      end

      def handle_error(e, recurly_sub_uuid)
        Airbrake.notify(
          error_class: self.class.to_s,
          error_message:     "Failed to upgrade recurly subscription uuid: #{recurly_sub_uuid}. Reason: #{e}",
          backtrace:         $ERROR_POSITION,
          environment_name:  ENV['RAILS_ENV']
        )
      end
  end
end
