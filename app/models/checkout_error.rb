# Organizes all Error objects for the checkout page, doesn't do any actual validation.
# At some point merge this code with the Checkout form object in app/forms/checkout.rb.

class CheckoutError
  def initialize(subscription = nil, chargify_customer = nil, chargify_subscription = nil)
    return nil if subscription.nil? || subscription.credit_card.nil?

    @subscription          = subscription
    @credit_card           = subscription.credit_card
    @chargify_customer     = chargify_customer
    @chargify_subscription = chargify_subscription

    merge_errors
    return self
  end

  def messages
    errors_count = TextHelper.pluralize(count_errors, 'Error')
    html = "#{errors_count} prevented your checkout from being completed."

    unless base_error_messages.blank?
      messages = base_error_messages.map { |msg| "<li>#{msg}</li>" }.join
      html << "<br/><br/><ul>#{messages}</ul>"
    end

    html.html_safe
  end

  private

    def merge_errors
      # TODO: this is covered by local validation, so it won't do anything...
      # Process chargify_customer errors.
      unless @chargify_customer.nil?
        @chargify_customer.errors.messages.each_pair do |k, messages|
          messages.each do |msg|
            @subscription.errors.add(k, "#{msg}.")
          end
        end
      end

      # IMPORTANT - Process credit_card errors before Chargify errors
      # IMPORTANT - (valid?) nukes the custom errors.
      @credit_card.valid?

      # Process chargify_subscription errors.
      unless @chargify_subscription.nil?
        @chargify_subscription.errors.messages.each_pair do |k, messages|
          messages.each do |msg|
            if msg.include?('expired')
              @credit_card.errors.add('expiration', 'Credit card cannot be expired.')
            elsif msg.include?("credit card number")
              @credit_card.errors.add('number', 'Must be valid credit card number.')
            elsif msg.downcase.include?('cvv')
              @credit_card.errors.add('cvv', "#{msg}.")
            elsif msg.downcase.include?('can only contain numbers')
              @credit_card.errors.add('cvv', "CVV #{msg}.")
            elsif msg.downcase.include?('duplicate')
              @subscription.errors.add(:base, "#{msg}.")
            elsif msg.downcase.include?('declined')
              @credit_card.errors.add(:base, "#{msg}.")
            elsif msg.downcase.include?('Street address and postal code do not match')
              @subscription.billing_address.errors.add(:base, "#{msg}.")
            elsif msg.downcase.include?('cannot be blank')
              Rails.logger.info "INVALID Chargify Subscription - ignored: #{msg}"
            else
              Rails.logger.info "INVALID Chargify Subscription - unhandled: #{msg}"
              @subscription.errors.add(:base, "#{msg}.")
            end
          end
        end
      end

      # These dont do anything and screw up the count.
      # Would love to factor them back in at some point, kinda a hack.
      @subscription.errors.delete(:billing_address)
      @subscription.errors.delete(:shipping_address)
    end

    def count_errors
      keys = @subscription.errors.messages.keys + @credit_card.errors.messages.keys

      if keys.include?(:base)
        return keys.count + base_error_messages.count - 1
      else
        return keys.count
      end
    end

    def base_error_messages
      sub_errors = (@subscription.errors.messages[:base] || [])
      cc_errors  = (@credit_card.errors.messages[:base] || [])
      ba_errors  = (@subscription.billing_address.errors.messages[:base] || [])

      sub_errors + cc_errors + ba_errors
    end
end
