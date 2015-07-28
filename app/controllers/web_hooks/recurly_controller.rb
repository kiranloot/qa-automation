module WebHooks
  class RecurlyController < ApplicationController
    http_basic_authenticate_with name: ENV['RECURLY_HTTP_AUTH_USERNAME'], password: ENV['RECURLY_HTTP_AUTH_PASSWORD']
    protect_from_forgery except: :dispatcher
    skip_before_filter :check_environment_password
    skip_before_action :verify_authenticity_token

    def dispatcher
      if handler.handle
        render nothing: true
      else
        render nothing: true, status: 422
      end
    end

    private
      def handler
        @handler ||= WebHooksHandler::Recurly.new(payload)
      end

      def payload
        request.raw_post
      end
      
      def user_for_paper_trail
        'Recurly API'
      end
  end
end