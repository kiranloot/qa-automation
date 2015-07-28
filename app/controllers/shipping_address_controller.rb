class ShippingAddressController < ApplicationController
  force_ssl if: :ssl_configured?
  before_action :authenticate_user!
  before_action :subscription, only: [:edit, :update]
  before_action :shipping_address, only: [:edit, :update]
  respond_to :html, :json

  def edit
  end

  def update
    @error_messages = []
    begin
      ShippingAddress.transaction do
        shipping_address.assign_attributes shipping_address_params
        @error_messages += shipping_address.errors.full_messages unless shipping_address.valid?

        if @error_messages.empty?
          shipping_address.save!
          shipping_address_service.update
        end
      end
    rescue StandardError => e
      env['airbrake.error_id'] = notify_airbrake(e)
      @error_messages << e.message
    end

    respond_to do |format|
      format.js
    end
  end

  # GET /shipping_address/states.js
  def states
    @target  = params[:target]
    @options = Address.state_options_for(params[:country])
    render json: @options, root: false
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def shipping_address_params
    params.require(:shipping_address).permit(:first_name, :last_name, :line_1, :line_2, :city, :state, :zip, :country)
  end

  def subscription
    @subscription ||= current_user.subscriptions.find(subscription_id)
  end

  def subscription_id
    params[:subscription_id]
  end

  def shipping_address
    @shipping_address ||= subscription.shipping_address
  end

  def shipping_address_id
    params[:id]
  end

  def shipping_address_service
    @shipping_address_service = @shipping_address_service || RecurlyAdapter::ShippingAddressService.new(subscription.recurly_account_id, shipping_address)
  end
end
