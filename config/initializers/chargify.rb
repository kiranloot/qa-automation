#config for chargify
require 'chargify_api_ares'

CHARGIFY_CONFIG = YAML::load_file(File.join(Rails.root, 'config', 'chargify.yml'))

Chargify.configure do |c|
  # always default to our new site (Braintree)
  c.subdomain = CHARGIFY_CONFIG[Rails.env]['braintree_subdomain']
  c.api_key = CHARGIFY_CONFIG[Rails.env]['api_key']
end

CHARGIFY_SHARED_KEY = ENV['CHARGIFY_SHARED_KEY'] || CHARGIFY_CONFIG[Rails.env]['shared_key']
CHARGIFY_BRAINTREE_SHARED_KEY = ENV['CHARGIFY_BRAINTREE_SHARED_KEY'] || CHARGIFY_CONFIG[Rails.env]['shared_braintree_key']