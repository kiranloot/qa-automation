Geocoder.configure(
  api_key: [ENV['SMARTY_STREETS_AUTH_ID'], ENV['SMARTY_STREETS_AUTH_TOKEN']],
  lookup: :smarty_streets,
  use_https: true
)
