require 'activemodel_errors_standard_methods'

class BillingAddress::Changer
  include ActiveModelErrorsStandardMethods

  def initialize(billing_address, subscription, options)
    @billing_address = billing_address
    @subscription    = subscription
    @options         = options
  end

  # May return errors or throw exceptions
  def perform
    BillingAddress.transaction do
      update_billing_address
      update_recurly if @errors.empty?
    end
  end

  private

  def update_billing_address
    @billing_address.assign_attributes @options
    merge_errors(@billing_address.errors) unless @billing_address.valid?
    @billing_address.save! if errors.empty?
  end

  def update_recurly
    billing_address_service.update
  end

  def billing_address_service
    @billing_address_service = @billing_address_service || RecurlyAdapter::BillingAddressService.new(recurly_account_id, @billing_address)
  end

  def recurly_account_id
    @subscription.recurly_account_id
  end
end
