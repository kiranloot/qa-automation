class Plan < ActiveRecord::Base
  TOP_PLAN_PERIOD = 12

  has_many :subscriptions
  has_many :checkouts
  has_and_belongs_to_many :promotions
  belongs_to :product

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :cost
  validates_presence_of :period
  validates_presence_of :shipping_and_handling
  validates_presence_of :savings_copy

  delegate :brand, to: :product, prefix: true
  delegate :name, to: :product, prefix: true

  def is_upgradable?
    period < TOP_PLAN_PERIOD
  end

  def is_legacy?
    self.name.strip =~ /.*-v\d$/ ? true : false
  end

  def readable_name
    name.gsub('-', ' ').gsub('12 month', '1 year')
  end

  def readable_title
    if 12 == period
      '1 year plan'
    else
      "#{period} month plan"
    end
  end

  def monthly_cost
    (cost / period - shipping_and_handling).round(2)
  end

  def image_file
    "#{period.to_i}_month_gray.jpg"
  end

  def country
    case name[0, 2]
    when 'au' then 'AU'
    when 'ca' then 'CA'
    when 'de' then 'DE'
    when 'dk' then 'DK'
    when 'fi' then 'FI'
    when 'fr' then 'FR'
    when 'gb' then 'GB'
    when 'ie' then 'IE'
    when 'nl' then 'NL'
    when 'no' then 'NO'
    when 'nz' then 'NZ'
    when 'se' then 'SE'
    else 'US'
    end
  end

  def display_name
    case name
    when 'amiibo-crate-three-weekly-payments'  then 'amiibo subscription'
    when 'amiibo-crate-single-payment'         then 'amiibo subscription'
    else readable_name
    end
  end

  def css_link_id
    "#{period.to_i.humanize}-month"
  end

  def is_amiibo?
    if 'amiibo-crate-three-weekly-payments' == name || 'amiibo-crate-single-payment' == name
      true
    else
      false
    end
  end
end
