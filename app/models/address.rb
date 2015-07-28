class Address < ActiveRecord::Base
  include Carmen

  # belongs_to :subscription, :autosave => true, :foreign_key => :subscription_id
  # has_many :subscriptions
  # accepts_nested_attributes_for :subscription

  validates_presence_of :first_name, :last_name
  validates_presence_of :line_1, :city, :state, :zip, :country

  validate :country_and_state_match

  def to_s
    line_1
  end

  def country_and_state_match
    if country.blank? || state.blank?
      false
    else
      valid_country?
      valid_state?
    end
  end

  # Country.coded is only used because it validates format of country
  def valid_country?
    if Country.coded(country).nil?
      if Country.named(country).nil?
        errors.add(:country, "isn't a Country supported on our system")
      else
        errors.add(:country, 'has to be in coded format')
      end

      false
    else
      true
    end
  end

  def valid_state?
    return false unless valid_country?

    c = Country.coded(country)

    if c.subregions.coded(state).nil?
      if c.subregions.named(state).nil?
        errors.add(:state, "isn't a State supported on our system")
      else
        errors.add(:state, 'has to be in coded format')
      end

      false
    else
      true
    end
  end

  # country in coded format US
  def self.state_options_for(country)
    options = [['', '']]

    # Handles the case that country "PLEASE SELECT" is selected.
    return options if country.empty?

    carmen_country = Country.named(country) || Country.coded(country)

    # Sort regions because of Armed Forces regions are custom and
    # options has default 'PLEASE SELECT' in it.
    carmen_country.subregions.sort_by(&:name).each do |state|
      if carmen_country.code == 'US'
        options << [state.code, state.code]
      else
        options << [state.name, state.code]
      end
    end

    options
  end

  def readable_state
    c = Country.named(country) || Country.coded(country)

    c.subregions.coded(state).name
  end
end
