class PromoCodeWorker
  include Sidekiq::Worker

  def perform(promo_id, recipients, prefix, length, quantity)
    promotion = Promotion.find(promo_id)
    coupons = create_coupons(prefix, length, quantity)

    if coupons.empty?
      handle_error(recipients, promotion)
    else
      handle_success(recipients, promotion, coupons)
    end
  end

  def self.multiuse(promotion, code)
    PromoCodeWorker.new.multiuse(promotion, code)
  end

  def multiuse(promotion, code)
    coupon = generate_coupon(code)
    add_codes_to_promo(promotion, [coupon])
  end

  private

  def handle_error(recipients, promotion)
    PromoMailer.error_codes(recipients, promotion).deliver_now
  end

  def handle_success(recipients, promotion, codes)
    add_codes_to_promo(promotion, codes)
    PromoMailer.send_codes(recipients, promotion, codes).deliver_now
  end

  def add_codes_to_promo(promotion, codes)
    promotion.coupons = codes
    promotion.save
  end

  def generate_code(prefix, length)
    "#{prefix}#{SecureRandom.hex}".truncate(length, omission: '')
  end

  def generate_coupon(code)
    Coupon.create(code: code, usage_count: 0)
  end

  def generate_coupons(prefix, length, quantity)
    coupons = {}
    attempt = 0
    attempt_limit = 10 * quantity

    while attempt < attempt_limit && coupons.length < quantity
      attempt += 1
      code = generate_code(prefix, length)
      next if coupons.has_key?(code)
      coupon = generate_coupon(code)
      if coupon.persisted?
        coupons[code] = coupon
      end
    end

    coupons.values
  end

  def create_coupons(prefix, length, quantity)
    coupons = generate_coupons(prefix, length, quantity)
    if coupons.length < quantity
      handle_create_failure(coupons)
    else
      coupons
    end
  end

  def handle_create_failure(coupons)
    coupons.each { |coupon| coupon.destroy }
    []
  end
end
