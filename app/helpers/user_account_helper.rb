module UserAccountHelper
  def link_type(subscription, current)
    link_to subscription == current ? 'selected' : 'view/edit',
      user_accounts_subscription_path(subscription), id: 'current_subscription'
  end

  # Reactivation is not available for active subs nor limited edition plans like amiibo
  def reactivation_available_for(subscription)
    return if subscription.subscription_status.in?(['active', 'past_due']) || subscription.plan.is_amiibo?

    link_to t('helpers.reactivate'), reactivation_subscription_path(subscription)
  end

  def masked_card_number(current_payment_info)
    if current_payment_info.credit_card.nil?
      t('helpers.currently_unavailable')
    else
      current_payment_info.credit_card.masked_card_number
    end
  end

  def number_friends_joined_via_referral
    current_user.redeemed_store_credits.pluck(:referred_user_id).count
  end

  # WARNING: Store credit is a decimal but we are purposely losing precision (converting to int)
  # according to frontend design specs
  def amount_earned_via_referral
    current_user.redeemed_store_credits.map(&:amount).inject(:+).to_i
  end

  def side_menu_title
    if current_page?('/user_accounts')
      title = t('user_accounts.navigation.account_info')
    end

    if current_page?('/user_accounts/subscriptions')
      title = t('user_accounts.navigation.subscriptions')
    end

    if current_page?('/user_accounts/store_credits')
      title = t('user_accounts.navigation.store_credits')
    end

    title
  end

  def includes_shirt?(subscription)
    subscription.plan.product.name.in? ['Core Crate', '+1 Wearable']
  end

  def is_upgradable?(subscription)
    subscription.is_active? && subscription.plan.is_upgradable? && !is_level_up?(subscription)
  end
end
