module StatesHelper
  include Carmen

  def postal_code_type(country)
    international?(country) ? 'Postal' : 'Zip'
  end

  def region_type(country)
    country.blank? ? 'State' : Country.coded(country).subregions.first.type.capitalize
  end

  def state_options(country)
    country.blank? ? [] : Address.state_options_for(Country.coded(country).name)
  end

  def country_options(country_code = nil)
    options = []
    if country_code
      c = Country.coded(country_code)
      options << [c.name, c.code]
    else
      Country.all.each { |country| options << [country.name, country.code] }
    end

    options
  end

end
