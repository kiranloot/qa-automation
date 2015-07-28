module RecurlyWorkers
  class RemoveAdjustment
    include Sidekiq::Worker

    def perform(adjustment_uuid)
      adjustment = Recurly::Adjustment.find adjustment_uuid

      adjustment.try(:destroy)
    end
  end
end