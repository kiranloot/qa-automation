module RebillCalc
  def self.calculate_rebill_date(utc=false)
    if /(Anime|Gaming)/.match($test.user.subscription.name)
      end_date = 28
    else
      end_date = 20
    end
    utc ? sub_day = Time.now.utc.to_date : sub_day = Date.today
    if sub_day.day > 5 && sub_day.day < end_date
      rebill_day = Date.new((sub_day >> $test.user.subscription.months.to_i).year,
                            (sub_day >> $test.user.subscription.months.to_i).month,
                            (utc ? 6 : 5))
    else
      rebill_day = sub_day >> $test.user.subscription.months.to_i
    end
    return{
      'month' => rebill_day.strftime('%B'),
      'month_abbr' => rebill_day.strftime('%b'),
      'day' => rebill_day.strftime('%d'),
      'year' => rebill_day.strftime('%Y')
    }
  end

  def self.localized_rebill
    rb = calculate_rebill_date
    "#{rb['month_abbr']} #{rb['day']}, #{rb['year']}"
  end

  def self.get_recurly_rebill(with_tz_offset = -8.0/24)
    $test.recurly.get_rebill_date(with_tz_offset)
  end

  def self.verify_recurly_rebill_date
    date_hash = calculate_rebill_date
    month_int = Date::MONTHNAMES.index(date_hash['month'])
    date_hash['month'] = month_int < 10 ? "0" + month_int.to_s : month_int.to_s
    recurly_rebill_date = get_recurly_rebill.to_s
    recurly_hash = {}
    recurly_hash['year'], recurly_hash['month'], recurly_hash['day'] = recurly_rebill_date.scan(/\d+/)
    ['year','month','day'].each do |key|
      expect(recurly_hash[key]).to eq date_hash[key]
    end
  end

  def self.verify_rebill_date
    calculated_rebill_date = calculate_rebill_date
    recurly_rebill = get_recurly_rebill
    expect(recurly_rebill.strftime('%Y')).to eq(calculated_rebill_date['year'])
    expect(recurly_rebill.strftime('%B')).to eq(calculated_rebill_date['month'])
    expect(recurly_rebill.strftime('%d')).to eq(calculated_rebill_date['day'])
  end

  def self.adjusted_rebill_date(original_rebill, months, direction)
    if direction == 'ahead'
    original_rebill_ymd = (original_rebill >> months).strftime('%F')
    elsif direction == 'behind'
    original_rebill_ymd = (original_rebill << months).strftime('%F')
    end
  end

  def self.convert_time_to_display_rebill(time)
    time = time.to_s
    year = time[0..3]
    month = time[5..6]
    date = time[8..9]
    month = Date::MONTHNAMES[month.to_i]
    return"#{month} #{date}, #{year}"
  end
end
