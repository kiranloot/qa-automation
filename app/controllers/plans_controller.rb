class PlansController < ApplicationController
  force_ssl if: :ssl_configured?
  respond_to :json

  def show
    @plan = Plan.find_by_name params[:id]

    if @plan
      plan_data    = @plan.attributes
      plan_cost    = sprintf("%0.02f", @plan.cost)
      monthly_cost = sprintf("%0.02f", (@plan.cost / @plan.period))
      extra_data   = {monthly_cost: monthly_cost, cost: plan_cost}

      render json: plan_data.merge(extra_data), status: 200
    else
      render json: {}, status: 404
    end
  end
end
