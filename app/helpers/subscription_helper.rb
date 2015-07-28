module SubscriptionHelper
  def cents_to_dollars(cents)
    dollars = cents / 100.0

    number_to_currency(dollars, locale: :en)
  end

  def is_level_up?(subscription)
    subscription.plan.product.brand == 'Level Up'
  end

  def skip_a_month_link(subscription)
    if subscription.month_skipped
      html = "You have skipped #{month_year_to_friendly_date(subscription.month_skipped)}"
    else
      html = link_to('SKIP', skip_a_month_preview_subscription_path(subscription), class: 'skip-a-month')
    end

    html.html_safe
  end

  def month_year_after_skip(month_year)
     date = month_year.to_date.next_month

     month_year_to_friendly_date(date)
  end

  def month_year_to_friendly_date(month_year)
    month_year.to_date.strftime('%B %Y').upcase
  end

  def skip_status(subscription)
    return unless subscription.month_skipped

    html = "(You have skipped #{month_year_to_friendly_date(subscription.month_skipped)})"

    html.html_safe
  end

  def recurly_subscription_link(uuid)
    "https://#{::Recurly.subdomain}.recurly.com/subscriptions/#{uuid}"
  end

  def recurly_account_link(account_code)
    "https://#{::Recurly.subdomain}.recurly.com/accounts/#{account_code}"
  end

  def recurly_invoice_link(invoice_number)
    "https://#{::Recurly.subdomain}.recurly.com/invoices/#{invoice_number}"
  end

  def recurly_transaction_link(uuid)
    "https://#{::Recurly.subdomain}.recurly.com/transactions/#{uuid}"
  end

  def redirect_subscription
    GlobalConstants::SOLDOUT ? '/sold_out' : '#'
  end

  # Show tracking history up to and including the current month's
  # crate, but only if it is the 17th or later
  def displayable_sorted_monthly_crates(subscription_units)
    # https://agile.lootcrate.com/browse/MWD-728 - need to not send tracking before the 17th

    today = DateTime.now
    subscription_units.reject {|su| today < su.crate_date.end_of_month &&
                                 today.day < 17 &&
                                 !su.shipped?}
      .sort {|x, y| x.crate_date <=> y.crate_date }
  end

  # Show the current month's tracking
  def display_current_monthly_crate(subscription)
    latest_period = subscription.latest_period

    last_unit = displayable_sorted_monthly_crates(latest_period.subscription_units).last
    last_unit if last_unit && last_unit.tracking_url.present?
  end

  def subscription_image(plan)
    case plan.period
    when 1 then '1_month_gray.jpg'
    when 3 then '3_month_gray.jpg'
    when 6 then '6_month_gray.jpg'
    when 12 then '12_month_gray.jpg'
    end
  end

  def subscription_status(subscription)
    if subscription.cancel_at_end_of_period && subscription.is_active?
      t('helpers.pending_cancellation')
    else
      subscription.subscription_status.to_s.titlecase
    end
  end

  def readable_title(plan)
    "#{plan.period} month plan"
  end

  def month_subscription(plan)
    "#{plan.period} Month Subscription"
  end

  def recurrent_fee(plan)
    "Recurring Fee (every #{plan.period} #{I18n.t('checkouts.subscriptions.months', count: plan.period)})"
  end

  def plan_is_1_year?(plan_name)
    plan_name =~ /12-month-subscription/
  end

  def current_unit_editable?(period)
    unit = Subscription::CurrentUnit.find(period)
    !(unit && unit.shipped?)
  end

  def subscription_class_count(subscriptions)
    subscriptions.count.odd? ? 'col-sm-6' : 'col-sm-12'
  end

  private

  def parse_month_year(month_year)
    Date.parse(month_year).strftime('%B %Y')
  end
end
