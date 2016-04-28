module ShipCycleChecker
  def self.before_shipping_cutoff?(crate)
    crate ||= 'Loot Crate'
    start_date = 5
    if crate == "Anime" || crate == "Gaming"
      end_date = 28
    else
      end_date = 20
    end
    puts Date.today.day
    puts crate
    puts end_date
    puts Date.today.day > start_date && Date.today.day < end_date
    return Date.today.day > start_date && Date.today.day < end_date
  end
end
