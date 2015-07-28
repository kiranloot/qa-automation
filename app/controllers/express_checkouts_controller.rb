class ExpressCheckoutsController < ApplicationController
  force_ssl if: :ssl_configured?
  before_filter :divert_when_soldout,         :only   => [:new, :create]
  before_filter :detour_not_logged_in,        :only   => [:new]
  before_filter :set_country,                 :only   => [:new, :index]
  before_filter :authenticate_user!,          :except => [:new, :index]
  respond_to :html, :json

  helper_method :unauthorized_coupon?, :readjusted_next_billing_date

  def new
    @checkout = plan.checkouts.build default_arguments.merge({coupon_code: coupon_code})
  end

  def create
    @checkout = plan.checkouts.build(checkout_params.merge(default_arguments))
    @checkout.credit_card_expiration_date = Date.new(checkout_params['credit_card_expiration_date(1i)'].to_i,
                                                     checkout_params['credit_card_expiration_date(2i)'].to_i,
                                                     checkout_params['credit_card_expiration_date(3i)'].to_i)

    @checkout.fulfill
    
    if !@checkout.errors.any?
      @subscription = @checkout.created_subscription
      setup_marketing_needs(@subscription)
      session[:successful_payment] = true
      redirect_new_subscriber
    else
      flash.now[:error] = decorated_errors(@checkout)
      render :new
    end
  end

  def update_summary
    checkout_update_params
    @checkout = plan.checkouts.build(checkout_update_params)
  end

  protected

  def readjusted_next_billing_date
    bill_date = current_datetime
    bill_date = bill_date.change(day: 5) if require_readjustment?
    bill_date += plan.period.months
  end

  def restricted_coupon?(code)
    code && code.start_with?('XQH') # this is completely arbitrary.
  end

  def unauthorized_coupon?(code)
    restricted_coupon?(code) && current_user.is_active?
  end

  private

  def redirect_new_subscriber
    redirect_to success_url
  end

  def default_arguments
    { user: current_user }
  end

  def success_url
    payment_completed_path(
      checkout: @checkout,
      id: @subscription.recurly_account_id,
      sid: @subscription.recurly_subscription_id,
      rev: @checkout.total,
      discount: @checkout.coupon_discount_amount,
      tax: @checkout.tax_charges_after_discount,
      pid: @checkout.plan.id
    )
  end

  def checkout_params
    params.require(:checkout).permit(
      :quantity,
      :chargify_coupon_code,
      :coupon_code,
      :state,
      *Checkout::COMMON_ATTRIBUTES
    )
  end

  def checkout_update_params
    params_hash = {}
    params_hash[:coupon_code] = params[:coupon_code] if params[:coupon_code].present?
    params_hash[:shipping_address_state] = params[:state] if params[:state].present?
    params_hash
  end

  def plan
    @plan = @plan || Plan.find_by(name: params[:plan])
  end

  def coupon_code
    @coupon_code = @coupon_code ||= params[:coupon_code]
  end

  # For new subs only!
  # Returns true if a recently create sub is between the 6th and the 19th
  def require_readjustment?
    current_datetime.day.between?(6, 19)
  end

  # Current DateTime in Eastern Time
  # Helper for determing if we need to readjust the rebill date (9PM PT cutoff time = 12AM ET)
  def current_datetime
    current_datetime = DateTime.current.in_time_zone('Eastern Time (US & Canada)')
  end

  # It seems like we are only interested in displaying non-form entry errors at the top
  def decorated_errors(checkout)
    errors_count = TextHelper.pluralize(checkout.errors.count, 'Error')
    html = "#{errors_count} prevented your checkout from being completed."
    unless checkout.errors[:subscription_gateway].blank?
      messages = checkout.errors[:subscription_gateway].map { |msg| "<li>#{msg}</li>" }.join
      html << "<br/><br/><ul>#{messages}</ul>"
    end

    html.html_safe
  end

  def setup_marketing_needs(subscription)
    current_user.save_utm(cookies)
    # UNLESS condition will last until Greg gives us the okay to go live
    unless Rails.env == 'production'
      AnalyticsWorkers::TrackSubscriptionPurchase.perform_async(current_user.id,
                                                                plan.name,
                                                                subscription.id,
                                                                checkout_total_in_cents,
                                                                sailthru_campaign_id)
    end
    tealium_event = Tealium::Event.new(user: current_user,
      subscription: subscription,
      event_type: :new_subscription_creation_success)
    session[:convertro_event_type] = tealium_event.convertro_event_type
  end

  def checkout_total_in_cents
    (@checkout.total.round(2) * 100).to_i
  end

  def sailthru_campaign_id
    cookies['sailthru_bid'] || cookies[:sailthru_bid]
  end
end
