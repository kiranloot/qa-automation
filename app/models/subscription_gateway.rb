require 'activemodel_errors_standard_methods'

# Subscription Gateway
# In charge of everything in regards to interacting with subscription gateways
class SubscriptionGateway
  include ActiveModelErrorsStandardMethods

  attr_accessor :checkout, :user

  def initialize(checkout, user)
    @checkout = checkout
    @user = user
  end

  def create_subscription
    ChargifySwapper.set_chargify_site_to_braintree

    begin
      @chargify_subscription = Chargify::Subscription.create(subscription_hash)

      if char_errors = @chargify_subscription.errors.presence
        process_gateway_errors(char_errors)
      end
    rescue => e
      handle_gateway_exceptions(e)
    end
  end

  def subscription
    @chargify_subscription
  end

  def customer
    chargify_customer = subscription.customer

    if chargify_customer.nil?
      chargify_customer = Chargify::Subscription.find(subscription.id).customer
    end

    chargify_customer
  end

  def self.readjust_rebilling_date(subscription, new_billing_datetime, _options = {})
    ChargifySwapper.set_chargify_site_for(subscription)
    chargify_subscription = Chargify::Subscription.find subscription.chargify_subscription_id
    if chargify_subscription
      chargify_subscription.next_billing_at = new_billing_datetime
      chargify_subscription.save
      true
    else
      false
    end
  end

  private
    def subscription_hash
      hash = subscription_attributes
      hash[:credit_card_attributes] = credit_card_attributes
      hash[:customer_attributes] = customer_attributes

      hash
    end

    def subscription_attributes
      {
        product_handle: checkout.plan_name,
        next_billing_at: nil,
        coupon_code: checkout.coupon_code
      }
    end

    def credit_card_attributes
      {
        first_name:        checkout.shipping_address_first_name,
        last_name:         checkout.shipping_address_last_name,
        expiration_year:   checkout.credit_card_expiration_date.year,
        expiration_month:  checkout.credit_card_expiration_date.month,
        cvv:               checkout.credit_card_cvv,
        full_number:       checkout.credit_card_number,
        billing_address:   checkout.billing_address_line_1,
        billing_address_2: checkout.billing_address_line_2,
        billing_city:      checkout.billing_address_city,
        billing_state:     checkout.billing_address_state,
        billing_zip:       checkout.billing_address_zip,
        billing_country:   checkout.billing_address_country
      }
    end

    def customer_attributes
      {
        email: user.email,
        first_name: checkout.shipping_address_first_name,
        last_name: checkout.shipping_address_last_name,
        address: checkout.shipping_address_line_1,
        address_2: checkout.shipping_address_line_2,
        city: checkout.shipping_address_city,
        state: checkout.shipping_address_state,
        zip: checkout.shipping_address_zip,
        country: checkout.shipping_address_country
      }
    end

    def process_gateway_errors(char_errors)
      char_errors.messages.each_pair do |k, messages|
        messages.each do |msg|
          if msg.include?('Coupon Code: has expired')
            errors.add(:subscription_gateway, 'Coupon code has expired.')
          elsif msg.include?('Credit card: cannot be expired.')
            errors.add(:credit_card_expiration_date, 'Credit card cannot be expired.')
          elsif msg.include?('credit card number')
            errors.add(:credit_card_number, 'Must be valid credit card number.')
          elsif msg.downcase.include?('cvv')
            errors.add(:credit_card_cvv, "#{msg}.")
          elsif msg.downcase.include?('can only contain numbers')
            errors.add(:credit_card_cvv, "CVV #{msg}.")
          elsif msg.downcase.include?('duplicate')
            errors.add(:subscription_gateway, "#{msg}.")
          elsif msg.downcase.include?('declined')
            errors.add(:subscription_gateway, "#{msg}.")
          elsif msg.downcase.include?('Street address and postal code do not match')
            errors.add(:subscription_gateway, "#{msg}.")
          elsif msg.downcase.include?('cannot be blank')
            Rails.logger.info "INVALID Chargify Subscription - ignored: #{msg}"
          else
            Rails.logger.info "INVALID Chargify Subscription - unhandled: #{msg}"
            errors.add(:subscription_gateway, "#{msg}.")
          end
        end
      end
    end

    def handle_gateway_exceptions(exception)
      if exception.message.include?('Timeout')
        errors.add(:subscription_gateway,
                    "Your subscription is in process of being created but is
                    taking too long.  Please contact customer support if problem
                    persist.  Resubmitting may create multiple subscriptions"
                  )
      else
        errors.add(:subscription_gateway_creation_error,
          "Error occurred and this incident has been reported.
          Please contact customer support if issue persist"
        )
      end

      Airbrake.notify(
        error_class:       'Local Subscription Creation Error:',
        error_message:     "Failed to create subscription: #{exception}",
        backtrace:         $ERROR_POSITION,
        environment_name:  ENV['RAILS_ENV']
      )
    end
end
