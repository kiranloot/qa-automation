module Friendbuy
  class API
    BASE_URI = 'https://api.friendbuy.com/v1'
    LOOTCRATE_SHORTEN_DOMAIN = 'http://looted.by'
    CREDENTIALS = {
                    username: ENV['FRIENDBUY_API_KEY'],
                    password: ENV['FRIENDBUY_API_SECRET']
                  }

    def initialize(options = {})
      @customer_id = options[:customer_id]
      @campaign_id = options[:campaign_id]
      @body        = options[:body] || {}
    end

    # Will get purl if one exists, else create it and return purl.
    def get_PURL
      @body[:customer] = { id: customer_id }
      @body[:campaign] = { id: campaign_id }

      response = post '/referral_codes'

      if response['trackable_link']
        response['purl'] = response['trackable_link']
      else
        Airbrake.notify(
           error_class:      'Friendbuy API get_PURL Error:',
           error_message:    "Unable to get PURL. Reason: #{response}",
           backtrace:        $@,
           environment_name: ENV['RAILS_ENV']
         )
      end

      response['purl']
    end

    def get_conversion(id)
      get "/conversions/#{id}"
    end

    # Create a conversion.
    # http://www.friendbuy.com/rest-api-reference/#purchases
    def post_conversion data
      @body[:order]         = data[:order]
      @body[:referral_code] = data[:referral_code]
      @body[:customer]      = data[:customer]
      @body[:products]      = data[:products]

      response = post 'purchases'

      response
    end

    private

    def post endpoint
      HTTParty.post("#{BASE_URI}/#{endpoint}", required_params)
    end

    def get endpoint
      HTTParty.get("#{BASE_URI}/#{endpoint}", required_params)
    end

    def required_params
      {
        body: "#{@body.to_json}",
        basic_auth: CREDENTIALS,
        headers: { 'Content-Type' => 'application/json' }
      }
    end

    def customer_id
      @customer_id.to_s
    end

    def campaign_id
      @campaign_id.to_i
    end
  end
end
