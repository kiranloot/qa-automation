Wombat.configure do |config|
  config.connection_token = ENV['WOMBAT_ACCESS_TOKEN']
  config.connection_id = ENV['WOMBAT_STORE']
end
