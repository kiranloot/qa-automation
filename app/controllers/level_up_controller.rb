class LevelUpController < ApplicationController  
  before_filter :set_country, :only => [:index]
  respond_to :html, :json, :js

  def index
    @products = Product.includes(:plans, variants: :inventory_unit).level_up.where(plans: { country: region, period: (0..6) }).order(created_at: :asc)
  end

  private
    def region
      internation_countries_code = GlobalConstants::SHIPPING_COUNTRIES_CODE.select { |code| code != 'US' }

      case cookies[:country]
      when *internation_countries_code
        'INT'
      else
        'US'
      end
    end
end