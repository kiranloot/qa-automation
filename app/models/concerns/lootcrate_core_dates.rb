module LootcrateCoreDates
  extend ActiveSupport::Concern
  SHIPPING_CUTOFF_DAY = 20
  
  def after_current_crate_cutoff_time?
    current_datetime.day >= SHIPPING_CUTOFF_DAY
  end

  def within_rebill_adjustment_rule?
    current_datetime.day.between?(6, 19)
  end

  def current_datetime
    DateTime.current.in_time_zone('Eastern Time (US & Canada)')
  end

  def current_crate_month_year
    Subscription::CrateDateCalculator.current_crate_month_year
  end

  def next_crate_month_year
    Subscription::CrateDateCalculator.next_crate_month_year
  end

  def current_month_year
    to_month_year(Date.today)
  end

  def current_month
    to_month(Date.today)
  end

  def next_month_year
    to_month_year(Date.today.next_month)
  end

  def next_month
    to_month(Date.today.next_month)
  end

  private
    def to_month_year(date)
      date.strftime('%^b%Y')
    end

    def to_month(date)
      date.strftime('%^B')
    end
end
