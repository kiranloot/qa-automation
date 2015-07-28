class WelcomeController < ApplicationController
  respond_to :html
  before_filter :set_country, only: [:international]

  def index
    @one_month_plan = PlanFinder.one_month_plan_for_country(cookies[:country])

    session[:mbsy] = params[:mbsy]
    session[:campaignid] = params[:campaignid]

    # this line is so we can respond to html requests only, AND render :index when taking requests from other methods listed below (e.g. international)
    respond_with (), template: 'welcome/index'
  end

  # same as index, except :set_country is called first
  def international
    index
  end
end
