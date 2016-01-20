module QAEnvironmentValidator
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

    if (config['DATABASE_URL'] == 'postgres://uepc1csoapak51:p2sigo8p4eeeqm7lgbb2mgkm8bq@ec2-174-129-245-179.compute-1.amazonaws.com:5492/daj5d11plkpskh')
      raise "===\nDatabase URL is configured to prod's\n==="
    end
    puts "Database verified"
  end
end
