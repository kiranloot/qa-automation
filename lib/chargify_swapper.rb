module ChargifySwapper
  def self.set_chargify_site_for(obj)
    subdomain_key = obj.braintree? ? 'braintree_subdomain' : 'authorize_dot_net_subdomain'
    # Rails.logger.info "setting site for #{obj.class} - #{obj.id}: #{subdomain_key}"
    set_site(subdomain_key)
  end

  def self.set_chargify_site_to_authorize
    # Rails.logger.info "manually setting site to authorize_dot_net_subdomain"
    set_site('authorize_dot_net_subdomain')
  end

  def self.set_chargify_site_to_braintree
    # Rails.logger.info "manually setting site to braintree_subdomain"
    set_site('braintree_subdomain')
  end

  private

    def self.set_site(subdomain_key)
      subdomain = CHARGIFY_CONFIG[Rails.env][subdomain_key]
      Chargify.subdomain = subdomain
      Chargify.site = "https://#{Chargify.subdomain}.chargify.com"
      Chargify::Base.site = Chargify.site
      # Rails.logger.info "site is now #{Chargify::Base.site} : #{Chargify.site}"

# TEMP CODE:
#if subdomain == 'authorize_dot_net_subdomain'
#  Chargify::Base.user = 'DFLe4nAkwg13WPSwqmWP'
#else
#  Chargify::Base.user = 'olc7xuk9utsSJIihJh79'
#end

    end
end
