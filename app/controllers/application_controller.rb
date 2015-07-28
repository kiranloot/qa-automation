class ApplicationController < ActionController::Base
  add_flash_types :error, :success

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  force_ssl if: :ssl_configured?
  protect_from_forgery
  before_filter :force_www
  before_filter :init_country
  before_filter :reset_locale
  before_filter :set_chargify_site
  before_filter :capture_utm
  before_filter :capture_pandora_utm

  if ENV['SITE_PASSWORD_REQUIRED'] == 'true'
    before_filter :check_environment_password
  end
  before_filter :tealium_tracking_udo

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  # This overrides Paper Trails' user_for_paper_trail method.
  # https://github.com/airblade/paper_trail
  def user_for_paper_trail
    current_admin_user.try(:email) || current_user.try(:id)
  end

  protected

  def after_sign_in_path_for(user)
    if user.is_a?(AdminUser)
      super
    else
      return request.referrer if request.referrer.try(:include?, 'level_up')
      session[:plan_choice_path] || stored_location_for(:user) || user_accounts_subscriptions_path
    end
  end

  # Force SSl
  def ssl_configured?
    #!Rails.env.development?
    return !(
      Rails.env.development? ||
      (params[:controller] == 'monthly' && params[:action] == 'experience'))
  end

  def authenticate_admin_user!
    #    authenticate_user!
    unless current_admin_user
      flash[:alert] = t('controllers.application.unauthorized_access')
      redirect_to root_path
    end
  end

  def tealium_tracking_udo
    options = {page_type: page_type}
    options[:user] = current_user if current_user

    @tealium_udo ||= ::Tealium::UniversalData.new(options)
  end

  def set_chargify_site
    # always always use the new braintree site unless we are accessing 'old' subscriptions (for updating purposes)
    ::ChargifySwapper.set_chargify_site_to_braintree
  end

  # require a username and password for staging environment (un/pw initially entered in querystring, then stored in cookies)
  def check_environment_password
    pass = ENV['SITE_PASSWORD'] # final four chars will get logged
    if cookies[:username] == pass # do nothing - proceed to site
    elsif request[:username] == pass # store cookie, and clear query string
      Rails.logger.info('Someone entered the correct password. password last 4: \'' + finaln(request[:username], 4) + '\'' +  ' ipaddr: \'' + request.remote_ip + '\'')
      cookies.permanent[:username] = pass
      redirect_to '/'
    elsif '/hooks/chargify' == request.original_fullpath.downcase[0, 15] # this elsif block is just to gather all the urls where access is allowed with no password
      Rails.logger.info('A request was allowed to avoid password verification:  uri = \'' + request.fullpath + '\'' +  ' ipaddr: \'' + request.remote_ip + '\'')
    else # Denied! Redirect to production site.
      Rails.logger.warn('Someone was denied entry. password: \'' + finaln(request[:username], 4) + '\'' +  ' ipaddr: \'' + request.remote_ip + '\'')
      redirect_to 'http://www.lootcrate.com/'
    end
  end

  # force users to use www subdomain, instead of bare lootcrate.com
  def force_www
    redirect_to "#{request.protocol}www.#{request.host_with_port}#{request.fullpath}", status: 301 if request.host == 'lootcrate.com'
  end

  def set_country
    # this if statement allows people to go to /join without defaulting their cookie
    if params.has_key?(:plan) || params.has_key?(:country)
      set_country_cookie(GlobalConstants::PLAN_COUNTRIES[params[:plan]] ||
                         GlobalConstants::PLAN_COUNTRIES[params[:country]])
      reset_locale
    end
  end

  # Block certain sections of the site when we are in SOLDOUT mode
  def divert_when_soldout
    redirect_to sold_out_path if GlobalConstants::SOLDOUT # no one is allowed here if we are in SOLDOUT mode
  end

  # Block amiibo section of the site when we don't have stock to supply another order
  def stock_remaining_amiibo?
    count = Subscription.find_by_sql("select 1 from subscriptions s join plans p on s.plan_id = p.id where p.name like 'amiibo%' and s.subscription_status = 'active'").count # get number of current amiibo subscriptions.  Consider adding dates to query for future use.
    count < GlobalConstants::CUTOFF_AMIIBO.to_i ? true : false
  end

  def detour_not_logged_in
    if current_user.nil?
      session[:plan_choice] = params[:plan] # Nanigans: this is used later for tracking in the nanigans pixel.
      session[:plan_choice_path] = new_checkout_path(plan: params[:plan])
      redirect_to new_user_registration_url unless user_signed_in?
    end
  end

  # override return_to if user already selected plan
  def require_plan
    redirect_to join_path if session[:plan_choice_path].nil?
  end

  def attempt_login
    if user = User.find_by_email(params[:new_user][:email])
      if user.valid_password?(params[:new_user][:password])
        sign_in_and_redirect(:user, user)
      end
    end
  end

  def clear_plan_choice
    session[:plan_choice_path] = nil
  end

  # Get the last n characters of a string, or less if the string is too short
  def finaln(input, n)
    result = ''
    unless input.nil?
      for i in 0..n
        if input.length == i || n == i
          result = input[-i, i]
          break
        end
      end
    end
    result
  end

  def page_type
    @page_type = @page_type ||= page_finder
  end

  def page_finder
    if controller_name == 'welcome' && action_name == 'index'
      'home'
    else
      controller_name + '_' + action_name
    end
  end

  private

  def init_country
    set_country_cookie(country_code_from_ip) unless cookies[:country].present?
  end

  def country_code_from_ip
    GEOIP_DB.country(request.remote_ip).try(:country_code2)
  end

  def set_country_cookie(code)
    cookies[:country] = {
      value:   code || 'US',
      expires: 1.year.from_now,
      path:    '/'
    }
  end

  def reset_locale
    # locale _always_ derives from the country cookie
    # (at least for now, given the fact that the two are driven by flag selection)
    locale_from_country_code(cookies[:country]).tap { |locale|
      I18n.locale = locale || I18n.default_locale
    }
  end

  def locale_from_country_code(country_code)
    locale = if GlobalConstants::LOCALES.include?(country_code)
      GlobalConstants::LOCALES[country_code]
    end
  end

  def capture_utm
    cookies[:lc_utm] = { value: utm.to_json, max_age: '25920000' } unless params[:utm_source].blank? || cookies[:lc_utm]
  end

  def utm
    {
      utm_source: params[:utm_source],
      utm_campaign: params[:utm_campaign],
      utm_medium: params[:utm_medium],
      utm_term: params[:utm_term],
      utm_content: params[:utm_content]
    }
  end

  # TODO: I hate this; not sure how to solve this without going through this path.
  def capture_pandora_utm
    return unless params[:utm_campaign] == 'Pandora'

    value = { aid: params[:aid], cid: params[:cid] }

    cookies[:pandora_utm] = {
      value: value.to_json,
      max_age: '25920000'
    }
  end
end