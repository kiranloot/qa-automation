# TTL 1 month from 2015/03/16 due to PR: 420
class CustomFailure < Devise::FailureApp
  def redirect_url
#     validate_cookie_path # REMOVED IN PR: 420
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end

