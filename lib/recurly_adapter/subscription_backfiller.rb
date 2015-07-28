require './lib/thread_utility' # Prevent Circular dependency detected while autoloading constant
require './app/models/subscription_backfiller_job'

module RecurlyAdapter
  # Initial Subscription backfilling for our Chargify to Recurly Migration
  class SubscriptionBackfiller

    def initialize(options = {})
      @job_queue = Queue.new
      @pool_size = options[:pool_size] || 30
    end

    def backfill
      backfill_log.info "Backfill started on #{DateTime.now}"
      populate_job_queue

      workers = @pool_size.times.map do
        Thread.new do
          begin
            while !@job_queue.empty? && backfill_jobs = @job_queue.pop(true)
              process(backfill_jobs)
            end
          rescue ThreadError => e
            backfill_log.error "ThreadError: #{e}"
          end
        end # thread
      end
      workers.map(&:join)
      backfill_log.info "Backfill completed on #{DateTime.now}"
    end

    def process(backfill_jobs)
      ThreadUtility.with_connection do
        backfill_jobs.each do |job|
          begin
            if recurly_sub = create_recurly_subscription(job)
              begin
                subscription = Subscription.find(job.subscription_id)
                subscription.assign_attributes(recurly_subscription_id: recurly_sub.uuid, recurly_account_id: recurly_sub.account.account_code)
                subscription.save! validate: false
              rescue => e
                puts e.message
              end
            end
          rescue Recurly::API::NotFound => e
            job.update_attribute(:status, 'account_not_found')
            backfill_log.error e.message
          end
        end
      end
    end

    private
    def create_recurly_subscription(job)
      begin
        if job.next_assessment_at <= DateTime.new(2015,06,26).at_end_of_day
          adjusted_assessment_date = DateTime.new(2015,06,29).at_middle_of_day
        else
          adjusted_assessment_date = job.next_assessment_at
        end
        recurly_sub = Recurly::Subscription.create(
          account: { account_code: job.account_code },
          plan_code: job.plan_code,
          currency: 'USD',
          starts_at: job.starts_at,
          trial_ends_at: adjusted_assessment_date
        )
        backfill_log.info "Backfilling #{job.account_code} - Success"
        job.update_attributes!(status: 'success')
        return recurly_sub
      rescue => exception
        backfill_log.info "!!! Backfilling #{job.account_code} - Failure: #{exception}"
        job.update_attributes!(status: 'failed')
        return nil
      end
    end

    def populate_job_queue
      SubscriptionBackfillerJob.where(status: [nil, 'account_not_found']).find_in_batches do |jobs|
        @job_queue.push(jobs)
      end
      backfill_log.info "Finished Populating Job Queue"
    end

    def backfill_log
      @backfill_log ||= Logger.new "#{Rails.root}/log/#{Rails.env}_recurly_backfill_#{DateTime.now.to_s(:number)}.log"
    end

    class << self
      def csv_import(filename)
        puts "Started: #{DateTime.now}"
        start_time = Time.now
        options = {chuck_size: 10000}
        columns = [:account_code, :plan_code, :starts_at, :next_assessment_at, :balance, :subscription_id]

        n = SmarterCSV.process(filename, options) do |chunk|
          transformed_chunk = chunk.map{|row|columns.map{|attr|row[attr] }}
          SubscriptionBackfillerJob.import(columns, transformed_chunk, validate: false )
        end
        puts "Took #{Time.now - start_time} for #{n} chunks"
      end

    end # end class
  end
end
