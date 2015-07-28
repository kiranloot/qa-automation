module MailerHelper
  def mailer_user(user)
    if user.full_name?
      user.full_name
    else
      'Looter'
    end
  end

  def delivery_subscription_month(subscription)
    delivery_date = subscription.created_at

    if within_cutoff?(delivery_date)
      delivery_date.strftime('%B')
    else
      (delivery_date + 1.month).strftime('%B')
    end
  end

  def total_cost(amount)
    sprintf("%.2f", amount)
  end

  private

  def within_cutoff?(delivery_date)
    delivery_date.in_time_zone('Eastern Time (US & Canada)').day.between?(1, 19)
  end

end
