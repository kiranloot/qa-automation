class UserMailer < ActionMailer::Base
  include MailerHelper
  default from: 'do-not-reply@lootcrate.com', from_name: 'do-not-reply@lootcrate.com'

  def expire_email(user)
    mandrill_class = MandrillMailer::TemplateMailer.new
    mandrill_class.mandrill_mail(
      from: 'do-not-reply@lootcrate.com',
      from_name: 'do-not-reply@lootcrate.com',
      template: 'expire-email',
      subject: I18n.t('email.subscription_cancellation'),
      to: user.email
    ).deliver
  end

  def reset_password_instructions(user, token, *args)
    edit_password_reset_url = edit_user_password_url(reset_password_token: token)

    mandrill_class = MandrillMailer::TemplateMailer.new
    mandrill_class.mandrill_mail(
      from: 'do-not-reply@lootcrate.com',
      from_name: 'do-not-reply@lootcrate.com',
      template: 'password-reset-instructions',
      subject: I18n.t('email.reset_password_instructions'),
      to: user.email,
      vars: {
        'FNAME' => mailer_user(user),
        'URL' => edit_password_reset_url
      }).deliver
  end
end
