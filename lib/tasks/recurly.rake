namespace :recurly do
  namespace :promotions do
    task :initialize => :environment do
      Promotion.order('created_at').each do |promotion|
        Rails.logger.level = Logger::INFO
        Rails.logger.info { "Submitting RecurlyWorkers::CouponWorker.perform_async job with promotion.id #{ promotion.id }." }
        RecurlyWorkers::CouponWorker.perform_async(promotion.id)
      end
    end
  end
end
