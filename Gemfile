source 'https://rubygems.org'

ruby '2.2.0'

gem 'actionpack-page_caching'
gem 'aspector'
gem 'route_downcaser'
gem 'newrelic_rpm'
gem 'rails', '~> 4.0' # initially 3.2.11, 3.2.13 on 20130407, 3.2.17 on 20140224, 3.2.18 on 20140507
gem 'turbolinks'
gem 'bootstrap-sass', '~> 3.3.4'
gem 'pg'
gem 'rake'#, '~> 0.8.7'
gem 'devise', '>= 2.1.2'
gem 'devise-encryptable'
gem 'dotenv-rails'
gem 'cancan', '>= 1.6.8'
gem 'rolify', '>= 3.2.0'
gem 'simple_form'#, '>= 2.0.4'
gem 'carmen', :git => 'https://github.com/dbellotti/carmen.git', :branch => 'overlay_data_path_fix'
gem 'carmen-rails', '~> 1.0.0'
gem 'chargify_api_ares'#, :git => 'git://github.com/aceofsales/chargify_api_ares.git', :branch => 'coupon-validate'
gem 'rails_config'
gem 'activeadmin', github: 'activeadmin/active_admin'
gem 'active_admin_import'
gem 'carrierwave'
gem 'unf'
gem 'fog'
gem 'rails-jquery-autocomplete'
gem 'jquery-scrollto-rails'
gem 'jquery-ui-rails'
gem 'jquery-waypoints-rails', '~> 2.0.5'
gem 'imagesLoaded_rails'
gem 'geoip'
gem 'gibbon', '~> 1.1.4'
gem 'figaro'
gem 'money-rails'
gem 'redis'
gem 'redlock'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'active_model_serializers'
gem 'font-awesome-sass', '~> 4.2.0'
gem 'survey-gizmo-ruby', :github => 'LootCrate/survey-gizmo-ruby', branch: 'rails4'
gem 'greensock-rails'
gem 'wombat-ruby', github: 'jsqu99/wombat-ruby', require: 'wombat'
gem 'gaffe'
gem 'rails-i18n', '~> 4.0.0'

# Mailers
gem 'mandrill_mailer'
gem 'sailthru-client', :require => 'sailthru' # MWD-967

# gem 'numbers_and_words' TTL 2015/05/20
gem 'humanize'

gem 'jquery-rails'
gem 'bcrypt', '~> 3.1.7'

# Exception Notification
gem 'airbrake'

gem 'connection_pool' # https://github.com/mperham/dalli - when using puma
gem 'puma'
gem 'rack-zippy'

gem 'full-name-splitter', '~> 0.1.2'

gem 'activerecord-import'
gem 'smarter_csv'

group :production, :staging do
  gem 'rails_12factor'
  gem 'rack-cors', :require => 'rack/cors'
  gem 'dalli'
  gem 'clockwork'
end

gem 'sprockets-rails'#, '~> 2.2.4'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'
gem 'cssminify'

group :development, :test, :staging do
  gem 'better_errors', :require => false
  gem 'binding_of_caller', :require => false
  gem 'faker'
  gem 'mailinator'
end

group :development, :test do
  # https://github.com/nixme/jazz_hands/issues/25#issuecomment-43281752
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'pry-byebug'   # This may or may not work with 2.1.2 either, so remove if you still get errorrs
  gem 'quiet_assets', '>= 1.0.1'
  gem 'factory_girl_rails', '>= 4.1.0'
  gem 'rspec-rails', '>= 2.11.4'
  gem 'shoulda-matchers', require: false
  gem 'meta_request', '0.2.1'
  gem 'timecop'
  gem "parallel_tests"
  #gem 'therubyracer'
  #  gem 'net-http-spy'
  gem 'vcr'
  gem 'capybara-console'
  gem 'selenium-webdriver', require: false
  gem 'sauce', '~> 3.1.1'
  gem 'sauce-connect'
  gem 'sauce-cucumber', require: false
end

group :development do
  gem 'foreman'
  gem 'letter_opener' # opens emails in the browser
  gem 'zeus'
  gem 'derailed_benchmarks'
  gem 'traceroute'
end

group :test do
  gem 'bourne'
  gem 'database_cleaner', '>= 0.9.1'
  gem 'launchy', '>= 2.1.2'
  gem 'capybara', '>= 1.1.2'
  gem 'cucumber-rails', require: false
  # http://ruby-journal.com/how-to-switch-between-selenium-and-poltergeist-for-rails-integration-rsped-test/
  gem 'poltergeist', require: false
  gem 'email_spec', '>= 1.2.1'
  gem 'simplecov', :require => false
  gem 'mocha', :require => false
  gem 'webmock'
  gem 'codeclimate-test-reporter', :require => false
  gem 'coveralls', :require => false
  gem 'mock_redis'
  gem 'rspec-activemodel-mocks'
  #Heroku API (for qa)
  gem 'platform-api'
end

# HTTP Request helper
gem 'httparty'

gem 'time_difference'

# Background job
gem 'sinatra'
gem 'sidekiq'

# Model change logs
gem 'paper_trail', '~> 4.0.0.beta'

# Customer Supports
gem "zendesk_api"

# for Subscription Order Handler
gem 'highline', require: false

# Frontend
gem 'font-awesome-rails'
gem 'masonry-rails'
gem 'select2-rails'

# Subscription Management Service
gem 'recurly', '~> 2.4.2'


# Tax calculations
gem 'geocoder'
gem 'avatax'
