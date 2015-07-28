require 'chargify_api_ares'

class PaymentCompletedController < ApplicationController
  before_filter :authenticate_user!

  def index
    redirect_to user_accounts_path unless session[:successful_payment] == true
    session.delete(:successful_payment)

    # always going to use new site for new payments
    @plan =  Plan.find(params[:pid])

    if session[:campaignid] == '475'
      if params[:pid] == '1'
        revenueamt = '7'
      elsif params[:pid] == '2'
        revenueamt = '9'
      else  # this should probably be:  elseif params[:pid] == '3'
        revenueamt = '12'
      end
    else
      revenueamt = '0'
    end

    @shortcode_url = ''

    @facebook_share_url = @plan.is_amiibo? ? 'http://lootcrate.com/amiibo' : @shortcode_url
    @customer_id = params[:id]
    @revenue = sanitize_precision(params[:rev] || 0)
    begin @revenue_in_cents = (Kernel::Float(@revenue) * 100).round; rescue Exception => e; Rails.logger.error(e.to_s); @revenue_in_cents = 0; end
    @transaction_id = params[:sid] # sid is actually the subscription id
    @unit_price = params[:rev] # this works because we only sell things one-at-a-time, so the 'total' and 'unit price' are the same.
    @discount = sanitize_precision(params[:discount] || 0)
    @subtotal = params[:subtotal] = convert_cents_to_dollars(@revenue_in_cents + (Kernel::Float(@discount) * 100).round)
    @tax = sanitize_precision(params[:tax] || 0)

    # Setup pixel tracking
    @yotpo_pixel = "<img src='https://api.yotpo.com/conversion_tracking.gif?order_amount=#{@revenue}&order_id=#{@transaction_id}&currency=USD&app_key=f3Obd1GcahWCH3N2LgTg7rUDQFx4VuZMZ4xa43re' width='1' height='1'>"
    unless session[:convertro_event_type].blank?
      @tealium_udo.convertro_event_type = session[:convertro_event_type]
      session[:convertro_event_type] = nil
    end
  end

  private

  def convert_cents_to_dollars(cents)
    sanitize_precision(cents.to_i / 100.0)
  end

  def sanitize_precision(amount)
    '%.2f' % amount
  end
end
