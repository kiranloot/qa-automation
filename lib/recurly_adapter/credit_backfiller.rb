require './lib/thread_utility' # Prevent Circular dependency detected while autoloading constant
require './app/models/subscription_backfiller_job'

module RecurlyAdapter
  class CreditBackfiller
    attr_reader :job_queue
    def initialize(pool_size = 30)
      @job_queue = Queue.new
      @pool_size = pool_size
    end

    def backfill
      populate_job_queue
      process_queue
    end

    # Populates job queue with collection of jobs with credit that needs to be redeemed
    def populate_job_queue
      SubscriptionBackfillerJob.where.not(balance: 0.0).where(status: 'success').find_in_batches do |jobs|
        @job_queue.push(jobs)
      end
      puts 'Populated Queue'
    end

    private
    def process_queue
      workers = @pool_size.times.map do
        Thread.new do
          begin
            while !@job_queue.empty? && backfill_job = @job_queue.pop(true)
              process(backfill_job)
            end
          rescue ThreadError => e
            puts "ThreadError: #{e.message}"
          end
        end
      end
      workers.map(&:join)
    end

    def process(jobs)
      ThreadUtility.with_connection do
        jobs.each do |job|
          begin
            backfill_log.info "Crediting #{job.account_code} with #{job.balance}"
            credit_account(job)
          rescue Recurly::API::NotFound => e
            job.update_attribute(:status, 'account_not_found')
            backfill_log.error e.message
          end
        end
      end
    end

    def credit_account(job)
      begin
        recurly_account = Recurly::Account.find(job.account_code)
        recurly_account.adjustments.create!(
          description:          'migrated from Chargify Subscription balance',
          unit_amount_in_cents: (job.balance*100).round,
          currency:             'USD',
          quantity:             1,
          accounting_code:      'migration_chargify'
        )
        backfill_log.info "Crediting #{job.account_code} - Success"
        job.update_attributes!(status: 'successful_credit')
      rescue => exception
        backfill_log.info "!!! Crediting #{job.account_code} - Failure - #{exception.message}"
        job.update_attributes!(status: 'failed_credit')
      end
    end

    def backfill_log
      @backfill_log ||= Logger.new "#{Rails.root}/log/#{Rails.env}_recurly_credit_backfill_#{DateTime.now.to_s(:number)}.log"
    end

  end
end
