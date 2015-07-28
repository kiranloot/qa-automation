module BillingInfoServiceInjector
  def billing_info_service
    Rails.configuration.billing_info_service
  end
end
