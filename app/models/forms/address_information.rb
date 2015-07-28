module Forms
  class AddressInformation
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    attr_accessor(
      :params,
      :address_id, :subscription_id,
      :subscription, :address, :chargify_customer,
      :first_name, :last_name, :line_1, :line_2, :city, :state, :zip, :country,
      :user, :error_summary, :type
    )

    # TODO - Eventually pull all validations except payment profile into this form
    #        as well as rewrite the checkout form view to use only this
    #        Forms::BillingInformation object.
    validate do
      unless address.valid?
        error_obj = Forms::Error.new(address, chargify_customer) # chargify_customer doesn't actually validate
        self.errors.add(:summary, error_obj.summary)
        self.error_summary = errors[:summary].first
      end
    end

    def initialize(params, user)
      @params              = params
      @address_id          = params[:id]
      @subscription_id     = params[:subscription_id]
      @first_name          = params[:address][:first_name]
      @last_name           = params[:address][:last_name]
      @line_1              = params[:address][:line_1]
      @line_2              = params[:address][:line_2]
      @city                = params[:address][:city]
      @state               = params[:address][:state]
      @zip                 = params[:address][:zip]
      @country             = params[:address][:country]

      # Assign all relevant objects
      #
      @subscription = user.subscriptions.find(subscription_id)
      @address = Address.find_by_id(@address_id)
      @address_type = @address.type

      ChargifySwapper.set_chargify_site_for(@subscription)
      @chargify_customer = Local::Chargify::Customer.find_by_id(subscription.customer_id)
    end

    def update
      # IMPORTANT - Once all the customer-subscriptions are remapped
      #             in Chargify, it is fine to remove this.
      puts "CORRUPT Subscription: #{subscription.id}, User: #{user.id}" if subscription.has_corrupt_mapping?

      ChargifySwapper.set_chargify_site_for(@subscription)

      # Update and validate both objects. Only update ChargifyCustomer
      # if Address updates and returns true
      if @address_type == 'BillingAddress'
        @address.update_attributes(address_params)
      else
        (@address.update_attributes(address_params) &&
        @chargify_customer.update_attributes(customer_address_hash))
      end

      valid?
    end

    def persisted?
      false
    end

    ## HELPERS ##
    def customer_address_hash
      {
        first_name: first_name,
        last_name:  last_name,
        address:    line_1,
        address_2:  line_2,
        city:       city,
        state:      state,
        zip:        zip
      }
    end

    private
    def address_params
      params.require(:address).permit(:first_name, :last_name, :line_1, :line_2, :city, :zip, :state, :country)
    end
  end
end
