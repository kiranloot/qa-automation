module SubscriptionCreationServiceInjector
  def subscription_creation_service
    Rails.configuration.subscription_creation_service
  end
end
