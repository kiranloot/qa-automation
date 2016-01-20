module ConfigVarVerification
  require_relative 'heroku_object'
  def self.verify
    heroku = HerokuAPI.new
    config = heroku.heroku.config_var.info(heroku.app)

    if (config['SAILTHRU_LOOTCRATE_DOMAIN'] == 'horizon.lootcrate.com')
      raise "===\nSailthru Domain is configured to prod environment\n==="
    end
    puts "Sailthru verified"

    if (config['RECURLY_SUBDOMAIN'] == 'lootcrate')
      raise "===\nRecurly Subdomain is configured to prod environment\n==="
    end
    puts "Recurly verified"
  end
end
