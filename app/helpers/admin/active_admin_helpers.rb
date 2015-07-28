module Admin::ActiveAdminHelpers
  def create_or_update_admin_promotion_path(promotion)
    if promotion.persisted?
      admin_promotion_path(promotion)
    else
      admin_promotions_path
    end
  end

  def promotion_coupon_codes
    @promotion.coupons.pluck(:code).join("\n")
  end

  def submit_button_text
    if @promotion.persisted?
      'UPDATE PROMOTION'
    else
      'CREATE PROMOTION'
    end
  end
end
