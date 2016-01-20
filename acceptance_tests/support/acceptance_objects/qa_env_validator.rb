module QAEnvironmentValidator
  require_relative 'heroku_object'
  def self.verify
    heroku = HerokuAPI.new
    config = heroku.heroku.config_var.info(heroku.app)



    #Verify Recurly subdomain
    if (config['RECURLY_SUBDOMAIN'] == 'lootcrate')
      raise "===\nRecurly Subdomain is configured to prod environment\n==="
    end
    puts "Recurly verified"

    #Verify Database URL
    if (config['DATABASE_URL'] == 'postgres://uepc1csoapak51:p2sigo8p4eeeqm7lgbb2mgkm8bq@ec2-174-129-245-179.compute-1.amazonaws.com:5492/daj5d11plkpskh')
      raise "===\nDatabase URL is configured to prod's\n==="
    end
    puts "Database verified"



    if (!heroku.app.include? 'admin')
      #Verify Sailthru domain
      if (config['SAILTHRU_LOOTCRATE_DOMAIN'] == 'horizon.lootcrate.com')
        raise "===\nSailthru Domain is configured to prod environment\n==="
      end
      puts "Sailthru verified"

      #Verify Alchemy endpoints
      if (config['CLOUDFRONT_CMS_ENDPOINT'] == 'd17d0a47rzlbdk.cloudfront.net')
        raise "===\nAlchemy endpoint is configured to prod's\n==="
      end

      if (config['AWS_PICTURES_DIRECTORY'] == 'lootcrate-alchemy-pictures')
        raise "===\nAlchemy pictures endpoint is configured to prod's\n==="
      end

      if (config['CMS_BACKUP_BUCKET'] == 'lootcrate-alchemy-backups')
        raise "===\nAlchemy backup endpoint is configured to prod's\n==="
      end
    end
  end
end
