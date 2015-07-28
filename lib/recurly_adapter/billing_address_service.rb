require 'activemodel_errors_standard_methods'

module RecurlyAdapter
  class BillingAddressService
    include ActiveModelErrorsStandardMethods

    def initialize(recurly_account_id, billing_address)
      @recurly_account_id = recurly_account_id
      @billing_address    = billing_address
    end

    def update
      unless recurly_account.billing_info.update_attributes attributes
        merge_recurly_errors(recurly_account.billing_info.errors)
      end
    end

    private

    def attributes
      @attributes = @attributes || RecurlyAdapter::BillingAddress.to_hash(@billing_address)
    end

    def recurly_account
      @recurly_account = @recurly_account || Recurly::Account.find(@recurly_account_id)
    end
  end
end
