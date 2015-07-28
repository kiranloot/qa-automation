module RecurlyAdapter
  class BillingInfoService
    include ActiveModel::Validations

    def initialize(subscription)
      @subscription = subscription
    end

    def update(payment_method_hash)
      recurly_billing_info_hash = remap(payment_method_hash)
      begin
        result = billing_info.update_attributes(recurly_billing_info_hash)
        self.errors.instance_variable_set("@messages", billing_info.errors) unless result
      rescue => e
        self.errors.add(:base, e.message)
      end
    end

    private

    def billing_info
      @billing_info ||= recurly_account.billing_info
    end

    def recurly_account
      @recurly_account ||= Recurly::Account.find(@subscription.recurly_account_id)
    end

    def remap(payment_method_hash)
      {
        first_name:         payment_method_hash[:first_name],
        last_name:          payment_method_hash[:last_name],
        number:             payment_method_hash[:full_number],
        month:              payment_method_hash[:expiration_month],
        year:               payment_method_hash[:expiration_year],
        verification_value: payment_method_hash[:cvv],
        address1:           payment_method_hash[:billing_address],
        address2:           payment_method_hash[:billing_address_2],
        city:               payment_method_hash[:billing_city],
        state:              payment_method_hash[:billing_state],
        zip:                payment_method_hash[:billing_zip],
        country:            payment_method_hash[:billing_country]
      }.reject { |key, value| value.nil? }
    end

  end
end
