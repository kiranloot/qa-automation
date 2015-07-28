module AccountWorkers
  class EmailUpdateWorker
    include Sidekiq::Worker

    def perform(old_email, new_email)
      sailthru_client.change_email(new_email, old_email)
    end

    private
    def sailthru_client
      @sailthru_client ||= Sailthru::Client.new(
        ENV['SAILTHRU_API_KEY'],
        ENV['SAILTHRU_API_SECRET'],
        ENV['SAILTHRU_API_URL']
    )
    end
  end
end
