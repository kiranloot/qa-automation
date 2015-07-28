class UserAccountsController < ApplicationController
  force_ssl if: :ssl_configured?
  before_filter :authenticate_user!
  before_filter :tealium_tracking_udo
  helper_method :resource
  helper_method :resource_name
  helper_method :devise_mapping
  include StatesHelper
  include SubscriptionHelper

  def index; end

  def subscriptions
    @subscriptions = current_user.subscriptions.includes(:billing_address, :shipping_address, :subscription_periods, :subscription_skipped_months).presence
    @upgradable_subscriptions = []

    # TODO: Move this into an upgrade finder or Subscription
    @subscriptions.each do |sub|
      @upgradable_subscriptions << sub if sub.is_upgradable? && !is_level_up?(sub)
    end if @subscriptions
  end

  def show
    @subscription = current_user.subscriptions.find(params[:id])
    @user = current_user
    @subscriptions = current_user.subscriptions
    @current_subscription = @subscription
    ChargifySwapper.set_chargify_site_for(@current_subscription)
    @current_payment_info = Local::Chargify::Subscription.find_by_id(@current_subscription.chargify_subscription_id)

    render :index
  end

  def update
    if current_user.update_attributes(user_params)
      redirect_to user_accounts_path, notice: t('controllers.user_account.user_updated')
    else
      redirect_to user_accounts_path, alert: t('controllers.user_account.unable_update_user')
    end
  end

  def update_email

    def email_param
      user_params[:email]
    end

    if current_user.email != email_param
      email_changer = User::EmailChanger.new(current_user, email_param)
      begin
        email_changer.perform

        if email_changer.errors.empty?
          redirect_to user_accounts_path, success: 'Email updated.'
        else
          redirect_to user_accounts_path, error: email_changer.errors.full_messages.to_sentence
        end
      rescue StandardError => e
        env['airbrake.error_id'] = notify_airbrake(e)
        redirect_to user_accounts_path, error: 'Unable to update user.'
      end
    else
      redirect_to user_accounts_path
    end
  end

  def update_password
    if current_user.valid_password?(user_params[:current_password])
      if current_user.update_attributes(user_params.except(:current_password))
        # Sign in the user by passing validation in case his password changed
        sign_in current_user, bypass: true
        redirect_to user_accounts_path, notice: t('devise.passwords.password_updated_successfully')
      else
        flash[:error] = t('devise.passwords.your_new_password_does_not_match')
        redirect_to user_accounts_path
      end
    else
      flash[:error] = t('devise.passwords.your_old_password_is_incorrect')
      redirect_to user_accounts_path
    end
  end

  private

  def store_credits; end

  # #since this is not a devise controller we need these helper methods for the form
  def resource
    @resource ||= User.new
  end

  def resource_name
    :user
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def tealium_tracking_udo
    @tealium_udo = @tealium_udo ||= Tealium::UniversalData.new(page_type: page_type, user: current_user)
  end

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation, :email, :full_name)
  end

end
