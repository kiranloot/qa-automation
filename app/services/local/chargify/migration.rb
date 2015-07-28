require 'chargify_api_ares'

# This class is needed because we are on version 0.6 which does not have preview.
# https://github.com/chargify/chargify_api_ares/blob/master/HISTORY.md
module Local
  module Chargify
    class Migration
      CREDENTIALS = {
                      username: ::Chargify.api_key,
                      password: 'x' #Chargify's password. Move this into ENV.
                    }

      def initialize chargify_subscription_id, product_handle
        @chargify_subscription_id = chargify_subscription_id
        @product_handle = product_handle
      end

      def preview
        response = {}

        begin
          response = post '/preview.json'
        rescue Exception => e
          response['errors'] ||= e
          Airbrake.notify(e)
        end

        response
      end

      private
      def post endpoint = ''
        HTTParty.post("#{migration_uri}#{endpoint}", required_params)
      end

      def required_params
        {
          body: {migration: {product_handle: [@product_handle]}}.to_json,
          basic_auth: CREDENTIALS,
          headers: { 'Content-Type' => 'application/json' }
        }
      end

      def migration_uri
        chargify_base_url = "#{::Chargify::Base.site}".chomp('/')

        "#{chargify_base_url}/subscriptions/#{@chargify_subscription_id}/migrations"
      end
    end
  end
end
