class Affiliate
  attr_accessor :name, :redirect_url, :redirect_url_escaped
  def initialize
    @name = 'affiliate_test'
    @redirect_url = 'google.com'
    @redirect_url_escaped = 'google.com'
  end
end
