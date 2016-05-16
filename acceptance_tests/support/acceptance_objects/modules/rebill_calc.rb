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

  def self.get_recurly_rebill(with_tz_offset = -8.0/24)
    $test.recurly.get_rebill_date(with_tz_offset)
  end

  def self.verify_rebill_date
    calculated_rebill_date = calculate_rebill_date
    recurly_rebill = get_recurly_rebill
    expect(recurly_rebill.strftime('%Y')).to eq(calculated_rebill_date['year'])
    expect(recurly_rebill.strftime('%B')).to eq(calculated_rebill_date['month'])
    expect(recurly_rebill.strftime('%d')).to eq(calculated_rebill_date['day'])
  end

end