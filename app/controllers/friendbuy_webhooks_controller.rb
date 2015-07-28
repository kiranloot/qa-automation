class FriendbuyWebhooksController < ApplicationController
  skip_before_filter :check_environment_password
  skip_before_action :verify_authenticity_token

  def share
    render nothing: true
  end

  def conversion
    FriendbuyEvent.new(params).new_conversion

    render nothing: true
  end
end
