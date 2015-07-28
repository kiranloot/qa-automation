class Zendesk::API < ZendeskAPI::Client
  def self.instance
    @client ||= new do |config|
      config.url = ENV["ZENDESK_API_URL"] # e.g. https://mydesk.zendesk.com/api/v2

      # Basic / Token Authentication
      config.username = ENV["ZENDESK_API_USERNAME"]

      # Choose one of the following depending on your authentication choice
      config.token = ENV["ZENDESK_API_TOKEN"]
      # config.password = "your zendesk password"

      # OAuth Authentication
      # config.access_token = "your OAuth access token"

      # Optional:

      # Retry uses middleware to notify the user
      # when hitting the rate limit, sleep automatically,
      # then retry the request.
      config.retry = true

      config.logger = Rails.logger

      # Changes Faraday adapter
      # config.adapter = :patron

      # Merged with the default client options hash
      # config.client_options = { :ssl => false }

      # When getting the error 'hostname does not match the server certificate'
      # use the API at https://yoursubdomain.zendesk.com/api/v2
    end
  end

  def search_tickets_by_email email
    search(query: "requester:#{email}")
  end
end