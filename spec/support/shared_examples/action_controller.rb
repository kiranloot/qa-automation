# We don't want SSL redirects in our test suite
module ActionController::ForceSSL::ClassMethods
  def force_ssl(options = {})
    # noop
  end
end
