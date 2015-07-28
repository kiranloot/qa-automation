class PasswordsController < Devise::PasswordsController

  protected

  def after_resetting_password_path_for(resource)
    user_accounts_path
  end
end
