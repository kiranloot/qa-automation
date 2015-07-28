class Subscription::UserChanger
  attr_reader :subscription, :new_user

  def initialize(subscription, new_user)
    @subscription = subscription
    @new_user = new_user
  end

  def perform

    update_info

  rescue StandardError => e
    Airbrake.notify(
      :error_class      => "Subscription User Change Error:",
      :error_message    => "Failed to change_user: #{e}",
      :backtrace        => $@,
      :environment_name => ENV['RAILS_ENV']
    )
    raise e
  end

private

  def update_info
    update_gateway_customer_account_email
    change_subscription_user
  end

  def change_subscription_user
    subscription.update_attributes user: new_user
  end

  def update_gateway_customer_account_email
    RecurlyAdapter::AccountService.new(subscription.recurly_account_id).update email: new_user.email
  end
end
