class FriendbuyEvent
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def new_conversion
    record_conversion
    credit_referrer
  end

  private

    def credit_referrer
      referrer = get_referrer

      if referrer
        referrer.store_credits.create!(
          amount: reward_amount,
          status: status,
          reason: "friendbuy-#{params[:share_id]}",
          referrer_user_id: referrer.id,
          referred_user_id: referred_user_id,
          referred_user_email: referred_user_email,
          referrer_user_email: referrer.email,
          friendbuy_conversion_id: params[:conversion_id])
      else
        # Must not have subscribed yet or used a different email address
        StoreCredit.create!(
          amount: reward_amount,
          status: status,
          reason: "friendbuy-#{params[:share_id]}",
          referrer_user_id: referrer_user_id,
          referred_user_id: referred_user_id,
          referred_user_email: referred_user_email,
          referrer_user_email: params[:email],
          friendbuy_conversion_id: params[:conversion_id])
      end
    end

    def get_referrer
      User.where(id: referrer_user_id).first || User.where(email: params[:email]).first
    end

    def record_conversion
      FriendbuyConversionEvent.create!(
        possible_self_referral:     params[:possible_self_referral],
        share_id:                   params[:share_id],
        new_order_ip_address:       params[:new_order_ip_address],
        network:                    params[:network],
        share_campaign_id:          params[:share_campaign_id],
        original_order_id:          params[:original_order_id],
        new_order_id:               params[:new_order_id],
        email:                      params[:email],
        share_campaign_name:        params[:share_campaign_name],
        original_order_customer_id: params[:original_order_customer_id],
        share_customer_id:          params[:share_customer_id],
        new_order_customer_id:      params[:new_order_customer_id],
        share_ip_address:           params[:share_ip_address],
        conversion_id:              params[:conversion_id],
        personal_url_customer_email: params[:personal_url_customer_email],
        reward_amount:              params[:reward_amount],
        new_order_customer_email:   params[:new_order_customer_email]
      )
    end

    def referred_user_id
      params[:new_order_customer_id]
    end

    def referred_user_email
      params[:new_order_customer_email]
    end

    def referrer_user_id
      params[:share_customer_id] || params[:personal_url_customer_id]
    end

    def referrer_email
      params[:email] || ''
    end

    def referrered_user_id
      params[:new_order_customer_id] || ''
    end

    def reward_amount
      params[:reward_amount].try(:to_f) || 0.0
    end

    def status
      if params[:possible_self_referral].try(:downcase) == 'true'
        'possible_self_referral'
      else
        'pending'
      end
    end
end
