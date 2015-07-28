class SessionsController < Devise::SessionsController
  force_ssl if: :ssl_configured?

  def create
    cookies.permanent[:remember_looter] = true
    # cookie for optimizely
    cookies[:loggedIn] = true
    super
  end

  def destroy
    # cookie for optimizely
    cookies[:loggedIn] = false
    super
  end
end
