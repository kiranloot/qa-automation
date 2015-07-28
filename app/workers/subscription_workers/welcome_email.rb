module SubscriptionWorkers
  class WelcomeEmail
    include Sidekiq::Worker

    def perform(user_id, sub_id)
      user = User.find user_id
      sub  = Subscription.find sub_id

      if is_levelup_product?(sub)
        SubscriptionMailer.levelup_purchase_confirmation(user, sub).deliver_now
      else
        SubscriptionMailer.signup(user, sub).deliver_now
      end
    end

    private
      def is_levelup_product?(sub)
        sub.plan.product_brand == 'Level Up'
      end
  end
end