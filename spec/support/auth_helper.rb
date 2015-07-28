module AuthHelper
  def http_login
    user = 'lootcrate'
    pw   = 'nopasswordhere'

    ENV['RECURLY_HTTP_AUTH_USERNAME'] = user
    ENV['RECURLY_HTTP_AUTH_PASSWORD'] = pw

    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
  end
end