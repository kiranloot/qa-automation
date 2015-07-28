AvaTax.configure do
  account_number ENV['AVATAX_ACCOUNT_NUMBER']
  license_key ENV['AVATAX_LICENSE_KEY']
  service_url ENV['AVATAX_SERVICE_URL']
end