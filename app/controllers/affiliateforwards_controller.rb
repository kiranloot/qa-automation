class AffiliateforwardsController < ApplicationController
  def get_affiliate
    affiliate = Affiliate.find_by_name_and_active params[:affiliate_name], true

    if affiliate
      redirect_to affiliate.redirect_url
    else
      redirect_to root_path
    end
  end
end
