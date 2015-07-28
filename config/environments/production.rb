Lootcrate::Application.configure do
  config.middleware.insert_before 0, "Rack::Cors" do
    allow do
      origins '*'
      resource '*', :headers => :any, :methods => [:get, :options]
    end
  end

  config.eager_load = true

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like nginx, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Choose the compressors to use
  config.assets.js_compressor  = :uglifier
  config.assets.css_compressor = CSSminify.new

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  config.serve_static_files = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Set to :debug to see everything in the log.
  config.log_level = :info

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  config.cache_store = :dalli_store,
                    (ENV["MEMCACHIER_SERVERS"] || "").split(","),
                    {:username => ENV["MEMCACHIER_USERNAME"],
                     :password => ENV["MEMCACHIER_PASSWORD"],
                     :failover => true,
                     :socket_timeout => 1.5,
                     :socket_failure_delay => 0.2,
                     :expires_in => 1.day,
                     :compress => true,
                     :pool_size => 5
                    }

# Enable serving of images, stylesheets, and JavaScripts from an asset server

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  config.action_controller.asset_host = ENV['CLOUDFRONT_ENDPOINT']

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w(*.svg *.eot *.woff *.ttf *.gif *.png *.ico *.jpg)

  # Precompile monthly contest Pages assets
  config.assets.precompile += %w(application.js application_contests.js
    layouts/pages/monthly/*.css application_contests.css
    application_user_accounts.css application_user_accounts.js
  )


  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Host ENV variable allows mailers to work in staging Heroku deployments.
  config.action_mailer.default_url_options = {
    :host => ENV['HOST'] || 'lootcrate.com'
  }
  # ActionMailer Config
  # Setup for production - deliveries, no errors raised
  config.action_mailer.delivery_method = :smtp
  #config.action_mailer.perform_deliveries = true
  #config.action_mailer.raise_delivery_errors = false
  #config.action_mailer.default :charset => "utf-8"

  config.action_mailer.smtp_settings = {
    :address    => "smtp.mandrillapp.com",
    :port       => 587,
    :user_name  => ENV['MANDRILL_USERNAME'],
    :password   => ENV['MANDRILL_API_KEY'],
    :domain     => 'lootcrate.com',
    :enable_startls_auto => true
  }

  # Disable automatic flushing of the log to improve performance.
  # config.autoflush_log = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Force SSL
  # http://www.simonecarletti.com/blog/2011/05/configuring-rails-3-https-ssl/
  # doing this in controllers for more precision, and to be able to use :status => :302
  #config.force_ssl = true
  #config.to_prepare {Devise::SessionsController.force_ssl}
  #config.to_prepare {Devise::RegistrationsController.force_ssl}
  config.subscription_creation_service = RecurlyAdapter::SubscriptionCreationService
  config.postponement_service = RecurlyAdapter::PostponementService
  config.billing_info_service = RecurlyAdapter::BillingInfoService
end
