class SubscriptionMailer < ActionMailer::Base
  include MailerHelper
  default from: 'do-not-reply@lootcrate.com', from_name: 'do-not-reply@lootcrate.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.signup.subject
  #
  def signup(user, subscription)
    delivery_month = delivery_subscription_month(subscription)

    mandrill_class = MandrillMailer::TemplateMailer.new
    mandrill_class.mandrill_mail(
      from: 'do-not-reply@lootcrate.com',
      from_name: 'do-not-reply@lootcrate.com',
      template: 'subscription-purchase-confirmation',
      subject: I18n.t('email.subscription_purchase_confirmation'),
      to: user.email,
      vars: {
        'SDATE' => delivery_month,
        'FNAME' => mailer_user(user),
        'SUBSCRIPTIONS' => subscription.plan_name,
        'SUBSCRIPTIONS_ORDER_TOTAL' => total_cost(subscription.plan_cost),
        'SUBSCRIPTIONS_PRICES' => total_cost(subscription.plan_cost),
        'URL' => user_accounts_url
      }).deliver
  end

  def legacy_invite_instructions(user)
    legacy_account_url = legacy_account_confirmation_url(:reset_password_token => user.reset_password_token, :legacy_invite => true)

    if user.encrypted_password.blank? and (user.sign_in_count == 0)
      user.generate_legacy_invite_tokens

      # send_special_invite_email
      mandrill_class = MandrillMailer::TemplateMailer.new
      mandrill_class.mandrill_mail(
        from: 'do-not-reply@lootcrate.com',
        from_name: 'do-not-reply@lootcrate.com',
        template: 'legacy-invite-instructions',
        subject: I18n.t('email.active_account'),
        to: user.email,
        vars: {
          'URL' => legacy_account_url
        }).deliver
    end
  end

  def reinvite(user)
    legacy_account_url = legacy_account_confirmation_url(:reset_password_token => user.reset_password_token, :legacy_invite => true)
    user.reset_password_sent_at = Time.now.utc.to_s
    user.save

    mandrill_class = MandrillMailer::TemplateMailer.new
    mandrill_class.mandrill_mail(
      from: 'do-not-reply@lootcrate.com',
      from_name: 'do-not-reply@lootcrate.com',
      template: 'reinvite',
      subject: I18n.t('email.active_account'),
      to: user.email,
      vars: {
        'URL' => legacy_account_url
      }).deliver
  end

  def cancel_at_end_of_period(subscription, cancellation_date)
    user              = subscription.user
    cancellation_date = cancellation_date

    mandrill_class = MandrillMailer::TemplateMailer.new
    mandrill_class.mandrill_mail(
      from: 'do-not-reply@lootcrate.com',
      from_name: 'do-not-reply@lootcrate.com',
      template: 'subscription-cancellation',
      subject: I18n.t('email.subscription_cancellation'),
      to: user.email,
      vars: {
        'LNAME' => mailer_user(user)
      }).deliver
  end

  def levelup_cancel_at_end_of_period(subscription, cancellation_date)
    user              = subscription.user
    cancellation_date = cancellation_date

    mandrill_class = MandrillMailer::TemplateMailer.new
    mandrill_class.mandrill_mail(
      from: 'do-not-reply@lootcrate.com',
      from_name: 'do-not-reply@lootcrate.com',
      template: 'level-up-cancellation',
      subject: I18n.t('email.subscription_cancellation'),
      to: user.email,
      vars: {
        'FNAME' => mailer_user(user),
        'URL' => user_accounts_subscriptions_url
      }).deliver
  end

  def levelup_purchase_confirmation(user, subscription)
    product_name = subscription.plan.product_name

    mandrill_class = MandrillMailer::TemplateMailer.new
    mandrill_class.mandrill_mail(
      from: 'do-not-reply@lootcrate.com',
      from_name: 'do-not-reply@lootcrate.com',
      template: 'level-up-successful',
      subject: I18n.t('email.levelup_subscription_purchase_confirmation'),
      to: user.email,
      vars: {
        'FNAME' => mailer_user(user),
        'ITEM' => product_name
      }).deliver
  end

  def undo_cancellation_at_end_of_period(subscription)
    user = subscription.user

    mandrill_class = MandrillMailer::TemplateMailer.new
    mandrill_class.mandrill_mail(
      from: 'do-not-reply@lootcrate.com',
      from_name: 'do-not-reply@lootcrate.com',
      template: 'remove-pending-cancellation',
      subject: I18n.t('email.remove_subscription_cancellation'),
      to: user.email,
      vars: {
        'LNAME' => mailer_user(user)
      }).deliver
  end

  def reactivated_subscription(subscription)
    user = subscription.user

    mandrill_class = MandrillMailer::TemplateMailer.new
    mandrill_class.mandrill_mail(
      from: 'do-not-reply@lootcrate.com',
      from_name: 'do-not-reply@lootcrate.com',
      template: 'reactivated-subscription',
      subject: I18n.t('email.reactivated_subscription'),
      to: user.email,
      vars: {
        'LNAME' => mailer_user(user)
      }).deliver
  end

  def upgrade(subscription)
    user = subscription.user
    plan = subscription.plan

    mandrill_class = MandrillMailer::TemplateMailer.new
    mandrill_class.mandrill_mail(
      from: 'do-not-reply@lootcrate.com',
      from_name: 'do-not-reply@lootcrate.com',
      template: 'subscription-upgraded',
      subject: I18n.t('email.subscription_upgraded'),
      to: user.email,
      vars: {
        'LNAME' => mailer_user(user)
      }).deliver
  end

  def skip_a_month(subscription)
    user               = subscription.user
    month_skipped = subscription.month_skipped.to_date.strftime('%B')

    mandrill_class = MandrillMailer::TemplateMailer.new
    mandrill_class.mandrill_mail(
      from: 'do-not-reply@lootcrate.com',
      from_name: 'do-not-reply@lootcrate.com',
      template: 'skip-month',
      subject: I18n.t('email.subscription_skipped'),
      to: user.email,
      vars: {
        'FNAME' => mailer_user(user),
        'MONTH' => month_skipped
      }).deliver
  end
end
