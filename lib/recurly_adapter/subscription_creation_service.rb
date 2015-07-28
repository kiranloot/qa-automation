require 'activemodel_errors_standard_methods'

module RecurlyAdapter
  class SubscriptionCreationService
    include ActiveModelErrorsStandardMethods

    attr_accessor :checkout, :user

    def initialize(checkout, user)
      @checkout = checkout
      @user = user
    end

    def create_subscription
      begin
        recurly_subscription.save!
      rescue Recurly::Resource::Invalid
        handle_invalid_resource_errors
      rescue => e
        handle_transaction_errors(e)
      end
    end

    def recurly_subscription
      @recurly_subscription ||= Recurly::Subscription.new(subscription_hash)
    end

    def subscription_id
      recurly_subscription.uuid
    end

    def account_id
      account.account_code
    end

    def account
      recurly_subscription.account
    end

    def billing_info
      account.billing_info
    end

    private
    def subscription_hash
      {
        plan_code: checkout.plan.name,
        account: build_account,
        coupon_code: RecurlyAdapter::CouponCode.new(@checkout.coupon_code).code,
        currency: 'USD'
      }
    end

    # TODO - Create unique accounts each time?
    def account_code
      @checkout.user.id + "_#{DateTime.now.strftime('%Y%m%d')}"
    end

    # REFACTOR_ME move into a module
    def first_renewal_date
      if day_of_the_month >= 6 && day_of_the_month < 20
        (Date.today + 1.month).change(day: 5)
      else
        Date.today
      end
    end

    def day_of_the_month
      current_datetime_in_eastern_time.day
    end

    def current_datetime_in_eastern_time
      DateTime.current.in_time_zone('Eastern Time (US & Canada)')
    end

    def build_account
      Recurly::Account.new({
        account_code: SecureRandom.uuid,
        email: @user.email,
        first_name: @checkout.billing_address_first_name,
        last_name: @checkout.billing_address_last_name,
        billing_info: build_billing_info,
        address: build_shipping_address
      })
    end

    def build_billing_info
      {
        address1: @checkout.billing_address_line_1,
        address2: @checkout.billing_address_line_2,
        city: @checkout.billing_address_city,
        state: @checkout.billing_address_state,
        country: @checkout.billing_address_country,
        zip: @checkout.billing_address_zip,
        number: @checkout.credit_card_number,
        month: @checkout.credit_card_expiration_date.month,
        year: @checkout.credit_card_expiration_date.year,
        verification_value: @checkout.credit_card_cvv
      }
    end

    def build_shipping_address
      Recurly::Address.new({
        address1: @checkout.shipping_address_line_1,
        address2: @checkout.shipping_address_line_2,
        city: @checkout.shipping_address_city,
        state: @checkout.shipping_address_state,
        country: @checkout.shipping_address_country,
        zip: @checkout.shipping_address_zip
      })
    end

    # NOTE: returning too much of detail might attract bad people to
    # wash credit cards on our site. At that point, we should be more generic
    def handle_transaction_errors(exception)
      message = exception.message.downcase
      if exception.message.include?('decline')
        errors.add(:credit_card_number, exception.message)
      elsif exception.message.include?('billing address')
        errors.add(:subscription_gateway, exception.message)
      elsif exception.message.include?('your card number is not valid')
        errors.add(:credit_card_number, 'Must be valid credit card number.')
      elsif exception.message.include?('Tax')
        errors.add(:subscription_gateway, 'Invalid zip code.')
      else
        errors.add(:subscription_gateway, exception.message)
      end
    end

    def handle_invalid_resource_errors
      all_errors = recurly_subscription.errors.merge(account.errors).merge(billing_info.errors)
      all_errors.full_messages.each do |msg|
        target = case msg
        when /(Account|Billing info) is invalid/i then next
        when /name/i                              then :billing_address_full_name
        when /expired/i                           then :credit_card_expiration_date
        when /valid credit card/i                 then :credit_card_number
        when /verification value/i                then :credit_card_cvv
        else :subscription_gateway
        end

        errors.add(target, msg)
      end
    end


  end
end
