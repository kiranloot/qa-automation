Lootcrate::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # MailCatcher Config
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.smtp_settings = {
    address: 'localhost',
    port: 1025
  }

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # This prevents precompiled assets from being used in dev environment (only necessary when using rake assets:precompile)
  # config.assets.prefix = "/dev-assets"

  config.middleware.use('SpoofIp', '64.71.24.19')
  # config.assets.compile = false
  #config.to_prepare { Devise::SessionsController.force_ssl l}
  #config.to_prepare { Devise::RegistrationsController.force_ssl }

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.subscription_creation_service = RecurlyAdapter::SubscriptionCreationService
  config.postponement_service = RecurlyAdapter::PostponementService
  config.billing_info_service = RecurlyAdapter::BillingInfoService
end
