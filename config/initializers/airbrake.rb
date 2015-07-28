Airbrake.configure do |config|
  config.api_key = '774e3606b60035456807391c7eff0a4a'
  config.async do |notice|
    AirbrakeDeliveryWorker.perform_async(notice.to_xml)
  end
end
