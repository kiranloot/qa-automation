class SubscriptionsController < ApplicationController
  force_ssl if: :ssl_configured?
  before_filter :divert_when_soldout,         :only   => [:new]
  before_filter :detour_not_logged_in,        :only   => [:new]
  before_filter :set_country,                 :only   => [:new, :index]
  before_filter :authenticate_user!,          :except => [:new, :index]
  before_filter :load_plan,                   :only   => [:new, :update_summary, :upgrade]
  before_filter :load_user_subscription,      :only   => [:edit, :reactivation,
                                                          :cancel_at_end_of_period,
                                                          :undo_cancellation_at_end_of_period,
                                                          :apply_coupon_for_reactivation,
                                                          :cancellation, :reactivate,
                                                          :upgrade_preview, :upgrade,
                                                          :skip_a_month, :update,
                                                          :change_plan, :skip_a_month_preview,
                                                          :skip_a_month_success]
  before_filter :divert_level_up,             :only   => [:upgrade_preview, :upgrade, :skip_a_month,
                                                          :skip_a_month_success, :skip_a_month_preview]
  before_filter :load_upgradable_plans,       :only   => [:upgrade_preview]
  around_action :lock_subscription,           :except => [:index, :edit, :upgrade_preview, :update_summary]

  respond_to :html, :json

  helper_method :unauthorized_coupon?, :readjusted_next_billing_date

  def index
  end

  # GET /edit
  def edit
  end

  # PUT /subscriptions/:id/cancel_at_end_of_period
  def cancel_at_end_of_period
    canceller = Subscription::Canceller.new(@subscription)
    canceller.cancel_at_end_of_period
    product_brand = @subscription.plan.product_brand

    if @subscription.cancel_at_end_of_period
      flash[:notice] = t('controllers.subscription.successfully_cancel_end_of_term')
      redirect_to user_accounts_subscriptions_path(survey: true, product_brand: product_brand)
    else
      flash[:error] = t('controllers.subscription.failed_cancel_end_of_term')
      redirect_to :back
    end
  end

  # PUT /subscriptions/:id/undo_cancellation_at_end_of_period
  def undo_cancellation_at_end_of_period
    canceller = Subscription::Canceller.new(@subscription)
    canceller.remove_cancel_at_end_of_period

    if canceller.errors.presence
      flash[:error] = t('controllers.subscription.failed_cancel_end_of_period')
    else
      flash[:notice] = t('controllers.subscription.successfully_cancel_end_of_period')
    end

    redirect_to :back
  end

  # GET /subscriptions/:id/reactivation
  def reactivation
    return redirect_to user_accounts_subscriptions_path if @subscription.is_active?

    reactivator = Subscription::Reactivator.new(@subscription, coupon_code: params[:coupon_code])
    @preview     = reactivator.preview
  end

  # PUT /subscriptions/:id/apply_coupon_for_reactivation
  # Format: JS
  def apply_coupon_for_reactivation
    reactivator            = Subscription::Reactivator.new(@subscription, coupon_code: params[:coupon_code])
    preview                = reactivator.preview
    preview[:valid_coupon] = preview[:amount_saved].to_i > 0 ? true : false

    respond_to do |format|
      format.json do
        render json: preview, status: 200
      end
    end
  end

  # GET /susbcriptions/:id/cancellation
  def cancellation
    redirect_to user_accounts_subscriptions_path if @subscription.cancel_at_end_of_period

    skipper        = Subscription::Skipper.new(@subscription)
    @month_to_skip = skipper.month_to_skip
    @month_to_skip_image   = skipper.month_to_skip_image.downcase
  end

  # PUT /subscriptions/:id/reactivate
  def reactivate
    reactivator = Subscription::Reactivator.new(@subscription, coupon_code: params[:coupon_code])

    reactivator.reactivate

    if error = reactivator.errors.presence
      flash[:error] = error.full_messages.to_sentence
    else
      flash[:notice] = t('controllers.subscription.subscription_successfuly_reactivated')
    end

    redirect_to user_accounts_subscriptions_path
  end

  # GET /subscriptions/:id/upgrade/preview
  def upgrade_preview
    unless @upgradable_plans.empty?
      @plan = Plan.find_by_name(params[:selected_product]) || @upgradable_plans.last
      upgrader = Subscription::Upgrader.new(@subscription, @plan)

      @upgrade_preview  = upgrader.preview
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  # PUT /subscriptions/:id/upgrade
  def upgrade
    upgrader = Subscription::Upgrader.new(@subscription, @plan)

    if upgrade_valid?(@plan)
      perform_upgrade(@subscription, @plan)
    else
      flash[:error] = 'Invalid upgrade option.  Please try again or contact customer support.'
    end

    redirect_to user_accounts_subscriptions_path
  end

  # PUT /subscriptions/:id/skip_a_month
  def skip_a_month
    skipper = Subscription::Skipper.new(@subscription)
    skipper.skip_a_month

    if errors = skipper.errors.presence
      flash[:error] = errors.full_messages.to_sentence
      redirect_to :back
    else
      flash[:notice] = t('controllers.subscription.successfully_skipped_a_month')
      redirect_to skip_a_month_success_subscription_path(@subscription)
    end

  end

  def skip_a_month_preview    
    if @subscription.month_skipped
      redirect_to user_accounts_subscriptions_path
    else
      skipper                = Subscription::Skipper.new(@subscription)
      @month_to_skip         = skipper.month_to_skip
      @month_to_skip_image   = skipper.month_to_skip_image.downcase
    end
  end

  def skip_a_month_success
    skipper                = Subscription::Skipper.new(@subscription)
    @month_to_skip_image   = skipper.month_to_skip_image.downcase
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.json
  def update
    respond_to do |format|
      if @subscription.update_attributes(subscription_params)
        flash[:notice] = t('controllers.subscription.successfully_updated_personal_information')
        load_upgradable_subscriptions

        format.html { redirect_to user_accounts_url }
        format.json { respond_with_bip(@subscription) }
        format.js
      else
        format.html {
          flash[:error] = @subscription.errors.full_messages.to_sentence
          render :edit
        }
        format.json { respond_with_bip(@subscription) }
        format.js { @error_messages = @subscription.errors.full_messages }
      end
    end
  end

  # PUT /subscriptions/validate_coupon.js
  def update_summary
    @state = params[:state]
    @coupon_code = params[:coupon_code]

    return redirect_to(join_path) if @plan.nil?

    unless @coupon_code.blank?
      if params.delete(:is_braintree) == '1'
        ChargifySwapper.set_chargify_site_to_braintree
      else
        ChargifySwapper.set_chargify_site_to_authorize
      end

      @coupon = validate_coupon(@coupon_code)

      params.delete(:coupon_code) if @coupon.nil?
    end

    calculate_summary
  end

  protected

  def populate_full_name(params)
    @subscription.looter_name = current_user.full_name = "#{params[:first_name]} #{params[:last_name]}"
  end

  def calculate_summary
    @total       = @plan.cost
    @today_total = @total

    if @coupon && @coupon.valid?
      @coupon_in_dollars = coupon_in_dollars(@coupon)
      @today_total      -= @coupon_in_dollars
      @today_total       = [@today_total, 0].max
    end

    if @state == 'CA'
      @tax         = california_tax(@today_total)
      @total       = @total.to_f + california_tax(@total)
      @today_total = @today_total.to_f + @tax
    end
  end

  def california_tax(total)
    (total * 0.09)
  end

  def coupon_in_dollars(coupon)
    if coupon
      if coupon.amount_in_cents
        coupon.amount_in_cents / 100
      elsif coupon.percentage
        @total * (coupon.percentage.to_f / 100)
      end
    else
      0
    end
  end

  def validate_coupon(code)
    coupon = nil
    if code &&
       (!restricted_coupon?(code) || !unauthorized_coupon?(code))

      coupon = Coupon.find_by_code(code)
    end
    coupon
  end

  def restricted_coupon?(code)
    code && code.start_with?('XQH') # this is completely arbitrary.
  end

  def unauthorized_coupon?(code)
    restricted_coupon?(code) && current_user.is_active?
  end

  private

  def lock_subscription
    lock_key = "lock:subscriptions:#{@subscription.id}"
    LOCKSMITH.lock(lock_key, 5000) do |lock_info|
      if lock_info
        yield
        LOCKSMITH.unlock(lock_info)
      end
    end
  end

  def upgrade_valid?(new_plan)
    load_upgradable_plans
    @upgradable_plans.include?(new_plan)
  end

  def perform_upgrade(subscription, plan)
    upgrader = Subscription::Upgrader.new(subscription, plan)

    upgrader.upgrade

    if upgrader.errors.any?
      flash[:error] = 'Subscription upgrade failed. Please update your billing information and try again.'      
    else
      flash[:notice] = 'Subscription upgraded successfully.'
    end
  end

  def load_upgradable_subscriptions
    @upgradable_subscriptions = []

    current_user.subscriptions.each do |subscription|
      @upgradable_subscriptions << subscription if subscription.is_upgradable?
    end if current_user.subscriptions
  end

  # Returns the next billing date based on the current date and plan
  def readjusted_next_billing_date
    bill_date = current_datetime
    bill_date = bill_date.change(day: 5) if require_readjustment?
    bill_date += plan.period.months
  end

  # For new subs only!
  # Returns true if a recently create sub is between the 6th and the 19th
  def require_readjustment?
    current_datetime.day.between?(6, 19)
  end

  def load_plan
    name = params[:upgrade_plan_name] || params[:plan]
    @plan ||= Plan.find_by_name(name)
  end

  def load_user_subscription
    @subscription = current_user.subscriptions.find(params[:id])
    set_chargify_site_for(@subscription)
  end

  def set_chargify_site_for(subscription)
    subscription && ChargifySwapper.set_chargify_site_for(subscription)
  end

  # Current DateTime in Eastern Time
  # Helper for determing if we need to readjust the rebill date (9PM PT cutoff time = 12AM ET)
  def current_datetime
    # TODO: Use LootcrateConfig.after_current_crate_cutoff_time?
    DateTime.current.in_time_zone('Eastern Time (US & Canada)')
  end

  def subscription_params
    params.require(:subscription).permit(:shirt_size, :name)
  end

  def load_upgradable_plans
    @upgradable_plans ||= PlanFinder.upgradable_plans_for(@subscription)
  end

  def divert_level_up
    redirect_to user_accounts_subscriptions_path if @subscription.plan.product_brand == 'Level Up'
  end
end
