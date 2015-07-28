module CheckoutsHelper
  def image_url_for_meta(plan)
    "#{request.base_url}#{asset_path(plan.image_file)}"
  end

  # MWD-1509 enable focus on different region of the checkout page
  def error_decorator
    return nil unless @checkout.errors.present?
    checkout_error_keys = @checkout.errors.messages.keys
    if checkout_error_keys.detect{|key| key.match(/shipping/) }
      "data-error=shipping-region"
    elsif checkout_error_keys.detect{|key| key.match(/billing|credit_card/) }
      "data-error=billing-region"
    elsif checkout_error_keys.detect{|key| key.match(/subscription_gateway/) }
      "data-error=review-region"
    else
      # oh noes.  some unknown error (probably subscription billing gateway)
      "data-error=shipping-region"
    end
  end

end
