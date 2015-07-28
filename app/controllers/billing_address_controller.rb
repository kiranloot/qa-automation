class BillingAddressController < ApplicationController
  force_ssl if: :ssl_configured?
  before_filter :authenticate_user!
  before_filter :subscription
  before_filter :billing_address
  respond_to :html, :json

  def update
    @error_messages = []

    begin
      billing_address_changer.perform
      @error_messages += billing_address_changer.errors.full_messages
    rescue StandardError => e
      env['airbrake.error_id'] = notify_airbrake(e)
      @error_messages << e.message
    end

    respond_to do |format|
      format.js
      format.html do
        if @billing_information.update
          flash[:notice] = t('controllers.billing_address.successfully_updated')
          redirect_to user_accounts_path
        else
          flash.now[:error] = @billing_information.error_summary
          render :edit
        end
      end

    end
  end

  private

  def billing_address_params
    params.require(:billing_address).permit(:line_1, :line_2, :city, :zip, :state, :country)
  end

  def subscription
    unless @subscription
      @subscription = current_user.subscriptions.find(subscription_id_param)
    end
    @subscription
  end

  def billing_address
    unless @billing_address
      @billing_address = current_user.billing_addresses.find(billing_address_id)
    end
    @billing_address
  end

  def subscription_id_param
    params[:subscription_id]
  end

  def billing_address_id
    params[:id]
  end

  def billing_address_changer
    @billing_address_changer = @billing_address_changer || BillingAddress::Changer.new(billing_address, subscription, billing_address_params)
  end
end
