class ReferralCreditRedeemer
  def initialize(store_credit)
    @store_credit = store_credit
  end

  def process
    credit_referrer if redeemable?
  end

  def credit_referrer
    if referrer_user.oldest_active_subscription.nil?
      @store_credit.update_attributes(status: 'active')
    else
      @store_credit.redeem(referrer_user.oldest_active_subscription)
    end
  end

  # it is redeemable if:
  #   * label has been printed
  def redeemable?
    !referred_user_subscription.current_unit.nil?
  end

  private
  def referred_user
    @store_credit.referred_user
  end

  def referred_user_subscription
    referred_user.subscriptions.last
  end

  def referrer_user
    @store_credit.referrer_user
  end

end
