module Forms
  class BillingInformation
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations
    include BillingInfoServiceInjector

    attr_accessor :params, :subscription_id, :subscription, :billing_address, :credit_card, :expiration_month, :expiration_year,
                  :cvv, :full_number, :full_name, :error_summary

    # TODO - Eventually pull all validations except payment profile into this form
    #        as well as rewrite the checkout form view to use only this
    #        Forms::BillingInformation object.
    validate do
      unless billing_update_service.errors.none? && billing_address.valid? && credit_card
        error_obj = PaymentProfileError.new(billing_update_service, credit_card, billing_address)
        self.error_summary = error_obj.summary

        error_messages = billing_address.errors.messages.merge(billing_update_service.errors.messages)
        error_messages = billing_address.errors.messages unless error_messages
        error_messages.each do |key, values|
          values.each { |value| self.errors.add(key, value) }
        end
      end
    end

    def initialize(params, billing_info_params, user)
      @params             = params
      @subscription_id    = params[:subscription_id]
      @full_name          = billing_info_params[:full_name]

      if billing_info_params[:credit_card]
        @expiration_month   = billing_info_params[:credit_card]['expiration(2i)']
        @expiration_year    = billing_info_params[:credit_card]['expiration(1i)']
        @cvv                = billing_info_params[:credit_card][:cvv]
        @full_number        = billing_info_params[:credit_card][:number]
      end

      # Assign all relevant objects
      #
      @subscription    = user.subscriptions.find(subscription_id)
      @billing_address = subscription.billing_address
      # Update BillingAddress before setting @credit_card
      @billing_address.assign_attributes(billing_info_params)
      @credit_card           = billing_address.credit_card
    end

    def update
      return false unless billing_address.valid?
      billing_update_service.update(payment_profile_hash)
      # Validate chargify subscription and credit card before
      # saving billing address locally.
      if valid?
        billing_address.save
        @subscription.update_attributes(last_4: credit_card_last_four)
      else
        false
      end
    end

    def persisted?
      false
    end

    ## HELPERS ##
    def payment_profile_hash
      first_name, last_name = full_name.try(:strip).try(:split, ' ', 2)

      {
        first_name:        first_name,
        last_name:         last_name,
        expiration_month:  credit_card.expiration.month,
        expiration_year:   credit_card.expiration.year,
        cvv:               credit_card.cvv,
        full_number:       credit_card.number,
      }.reject { |k,v| v.nil? }
    end

    private
    def billing_update_service
      @billing_update_service ||= billing_info_service.new(@subscription)
    end

    def credit_card_last_four
      credit_card.number.split('-').last[-4..-1]
    end

  end
end
