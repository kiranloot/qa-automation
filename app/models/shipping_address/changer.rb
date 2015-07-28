require 'activemodel_errors_standard_methods'

class ShippingAddress::Changer
  include ActiveModelErrorsStandardMethods

  def initialize(shipping_address, subscription, options)
    @shipping_address = shipping_address
    @subscription    = subscription
    @options         = options
  end

  # May return errors or throw exceptions
  def perform
    ShippingAddress.transaction do
      update_shipping_address
      update_recurly if @errors.empty?
    end
  end

  private

  def update_shipping_address
    @shipping_address.assign_attributes @options
    merge_errors(@shipping_address.errors) unless @shipping_address.valid?
    @shipping_address.save! if errors.empty?
  end

  def update_recurly
    shipping_address_service.update
  end

  def shipping_address_service
    @shipping_address_service ||= RecurlyAdapter::ShippingAddressService.new(recurly_account_id, @shipping_address)
  end

  def recurly_account_id
    @subscription.recurly_account_id
  end
end
