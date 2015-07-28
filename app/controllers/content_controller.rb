class ContentController < ApplicationController
  before_filter :authenticate_user!

  def silver
    authorize! :view, :silver, message: 'Access limited to One month plan subscribers.'
    # recordambassador("1")
  end

  def gold
    authorize! :view, :gold, message: 'Access limited to Three month plan subscribers.'
    # recordambassador("2")
  end

  def platinum
    authorize! :view, :platinum, message: 'Access limited to Six month plan subscribers.'
    # recordambassador("3")
  end

  private

  def recordambassador(subscription_id)
    username = 'lootcrate'
    api_key = '75fe8658be91d11f7692d4b01f294d30'
    response_type = 'json'
    email = current_user.email

    uri = URI.parse("https://getambassador.com/api/v2/#{username}/#{api_key}/#{response_type}/event/record/")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    if session[:campaignid] == '475'
      if subscription_id == '1'
        revenueamt = '7'
      elsif subscription_id == '2'
        revenueamt = '9'
      else
        revenueamt = '12'
      end
    else
      revenueamt = '0'
    end

    request = Net::HTTP::Post.new(uri.request_uri)

    if session.has_key?(:mbsy) && session.has_key?(:campaignid)
      request.set_form_data({ 'short_code' => session[:mbsy], 'revenue' => revenueamt,  'email' => email, 'sandbox' => '0',  'campaign_uid' => session[:campaignid] })
    else
      request.set_form_data({ 'email' => email, 'sandbox' => '0',  'campaign_uid' => '407' })
    end

    response = http.request(request)

    puts response.body

    json = JSON.parse(response.body)

    resp = json['response']['data']['ambassador']['campaign_links']
    resp.each do |item|
      @shortcode_url = item['url']
    end
  end
end
