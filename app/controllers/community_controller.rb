class CommunityController < ApplicationController
  # All this 'show/hide postano' mumbo-jumbo can be removed eventually.
  # It was necessary when Postano didn't work over SSL, (but our complaints forced Postano to fix the problem).
  # - Note that the view relies on @showpostano == true

  # before_filter :force_non_ssl
  before_filter :set_postano

  def index
  end

  # used for testing: get 'community/showpostano',   to: 'community#showpostano'
  def showpostano
    @showpostano = true
    render :index
  end

  # used for testing get: 'community/hidepostano',   to: 'community#hidepostano'
  def hidepostano
    @showpostano = false
    render :index
  end

  protected

  def force_non_ssl
    redirect_to protocol: 'http://', status: 302 if request.ssl? # && Rails.env.production?
  end

  def set_postano
    # @showpostano = !request.ssl? #this was used to turn off postano when using SSL, (Postano used to not work over SSL).
    @showpostano = true
  end
end
