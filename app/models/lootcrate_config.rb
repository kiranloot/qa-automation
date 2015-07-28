module LootcrateConfig
  class << self
    def after_current_crate_cutoff_time?
      current_datetime.day >= shipping_cutoff_day
    end

    def within_rebill_adjustment_rule?
      current_datetime.day.between?(rebill_start_date, shipping_cutoff_day - 1 )
    end

    def current_datetime
      DateTime.current.in_time_zone('Eastern Time (US & Canada)')
    end

    def shipping_cutoff_day
      Rails.env.staging? ? ( ENV['SHIPPING_CUTOFF_DAY'] || 20 ) : 20
    end

    def rebill_start_date
      Rails.env.staging? ? (ENV['REBILL_START_DATE'] || 6 ) : 6
    end
  end
end
