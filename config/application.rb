require File.expand_path('../boot', __FILE__)

# Load heroku ENV vars from local file (for development environment only - file should not exist elsewhere)
heroku_env = File.expand_path('../heroku_env.rb', __FILE__)
load(heroku_env) if File.exists?(heroku_env)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Lootcrate
  class Application < Rails::Application

    config.sass.preferred_syntax = :scss

    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl
    end

    config.autoload_paths += %W(#{config.root}/lib)

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Pacific Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :en

    #fonts
    config.assets.paths << "#{Rails.root}/app/assets/fonts"
    config.assets.precompile += %w( .svg .eot .woff .ttf )

    # Active Admin uses Inherited Resources and all scaffolds will use it by default.
    # We are changing that adding this line.
    config.app_generators.scaffold_controller = :scaffold_controller

    # Prevent postgres from trying to connect before it has config vars, to enable Heroku's rake assets:precompile
    # https://devcenter.heroku.com/articles/rails-asset-pipeline#troubleshooting
    config.assets.initialize_on_precompile = false

    # add active admin assets to precompile list, loaded from vendor/assets
    config.assets.precompile += %w( active_admin.js active_admin.css autocomplete-rails.js)


    # Disable Rails's static asset server (Apache or nginx will already do this)
    # https://devcenter.heroku.com/articles/ruby-support
    config.serve_static_files = true

    # Force SSL : this is false for dev environment, set to true in config/production
    # http://www.simonecarletti.com/blog/2011/05/configuring-rails-3-https-ssl/
    #config.force_ssl = false

    # Don't supress errors in after_rollback and after_commit callbacks
    config.active_record.raise_in_transactional_callbacks = true
  end
end

# These are very useful in development but break rspec :(
unless Rails.env == "production" or Rails.env == "test"
  require 'better_errors'
  require 'binding_of_caller'
end
