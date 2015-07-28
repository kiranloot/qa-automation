class RegistrationsController < Devise::RegistrationsController
  force_ssl if: :ssl_configured?
  before_filter :require_no_authentication, :only => [:validate_cookie]
  before_filter :require_plan,              :only => [:new]
  before_filter :attempt_login,             :only => [:create]

  def create
    build_resource(registration_params)

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end

      NewAccountWorkers::EmailSubscriber.perform_async resource.id
    else
      clean_up_passwords resource
      flash.now[:error] = resource.errors.full_messages.to_sentence
      respond_with resource
    end
  end

  def update
    super
  end

  protected

  def after_update_path_for(resource)
    user_accounts_path
  end

  def registration_params
    params.require(:new_user).permit(:email, :password)
  end
end
