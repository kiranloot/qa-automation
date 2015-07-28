module Forms
  class ShippingInformation
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    attr_accessor :shipping_address, :subscription, :shipping_address_params, :chargify_customer,
      :error_summary

    # TODO - Eventually add validations on this class instead of the objects
    #        shipping_address and chargify_customer.
    #
    validate do
      unless shipping_address.valid?
        error_obj = Forms::Error.new(shipping_address, chargify_customer) # chargify_customer doesn't actually validate
        self.errors.add(:summary, error_obj.summary)
        self.error_summary = errors[:summary].first
      end
    end

    def initialize(subscription, shipping_address, chargify_customer, shipping_address_params)
      @subscription         = subscription      # user.subscriptions.find(subscription_id)
      @shipping_address     = shipping_address  # subscription.shipping_address
      @shipping_address_params = shipping_address_params
      @chargify_customer    = chargify_customer # Local::Chargify::Customer.find_by_id(subscription.customer_id)

      ChargifySwapper.set_chargify_site_for(subscription)
    end

    def update
      # IMPORTANT - Once all the customer-subscriptions are remapped
      #             in Chargify, it is fine to remove this.
      puts "CORRUPT Subscription: #{subscription.id}, User: #{user.id}" if subscription.has_corrupt_mapping?

      ChargifySwapper.set_chargify_site_for(subscription)

      # Update and validate both objects. Only update ChargifyCustomer
      # if ShippingAddress updates and returns true
      (@shipping_address.update_attributes(shipping_address_params) &&
       @chargify_customer.update_attributes(customer_address_hash))

      valid?
    end

    def persisted?
      false
    end

    ## HELPERS ##
    def customer_address_hash
      {
        first_name: shipping_address_params[:first_name],
        last_name:  shipping_address_params[:last_name],
        address:    shipping_address_params[:line_1],
        address_2:  shipping_address_params[:line_2],
        city:       shipping_address_params[:city],
        state:      shipping_address_params[:state],
        zip:        shipping_address_params[:zip]
      }
    end

    private

    def user
      subscription.user
    end
  end
end
