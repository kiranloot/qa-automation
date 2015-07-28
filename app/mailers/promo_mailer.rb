class PromoMailer < ActionMailer::Base
  default from: 'do-not-reply@lootcrate.com'

  def send_codes(recipients, promotion, codes)
    @promotion = promotion
    attachments['codes.txt'] = generate_codes_attachment(codes)
    mail(to: recipients, subject: "[Done] Promo Codes for #{promotion.name}")
  end

  def error_codes(recipients, promotion)
    @promotion = promotion
    mail(to: recipients, subject: "[Failed] Promo Codes for #{promotion.name}")
  end

  private

  def generate_codes_attachment(codes)
    codes.collect { |coupon| coupon.code }.join("\n")
  end
end
