module AccountWorkers
  class ResetPasswordEmail
    include Sidekiq::Worker

    def perform(user_id, token, args={})
      user = User.find(user_id)
      UserMailer.reset_password_instructions(user, token).deliver_now
    end
  end
end