module NewAccountWorkers
  class EmailSubscriber
    include Sidekiq::Worker

    def perform(user_id)
      user = User.find user_id

      Sailthru::ListManager.new(user).subscribe_new_account
    end
  end
end
