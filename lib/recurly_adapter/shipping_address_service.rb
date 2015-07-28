module RecurlyAdapter
  class ShippingAddressService
    def initialize(recurly_account_id, shipping_address)
      @recurly_account_id = recurly_account_id
      @shipping_address = shipping_address
    end

    def update
      recurly_account_service = RecurlyAdapter::AccountService.new(@recurly_account_id)
      recurly_account_service.update(RecurlyAdapter::ShippingAddress.to_hash(@shipping_address))
    end
  end
end
