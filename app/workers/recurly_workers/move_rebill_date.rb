module RecurlyWorkers
  class MoveRebillDate
    include Sidekiq::Worker

    def perform(sub_uuid, next_assessment_at)
      subscription = Recurly::Subscription.find sub_uuid

      subscription.postpone(next_assessment_at)
    end
  end
end