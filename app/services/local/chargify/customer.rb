require 'chargify_api_ares'

module Local
  module Chargify
    class Customer

      def initialize(params = nil, user = nil)
        @params           = params
        @billing_address  = params[:subscription][:billing_address_attributes]
        @shipping_address = params[:subscription][:shipping_address_attributes]
        @user             = user
      end

      def create
        begin
          customer_hash = {
            email:      @user.email,
            first_name: @shipping_address[:first_name],
            last_name:  @shipping_address[:last_name],
            address:    @shipping_address[:line_1],
            address_2:  @shipping_address[:line_2],
            city:       @shipping_address[:city],
            state:      @shipping_address[:state],
            zip:        @shipping_address[:zip],
            country:    @shipping_address[:country]
            # :reference => current_user.id
          }
          customer = ::Chargify::Customer.create(customer_hash)
          customer
        rescue => e
          Rails.logger.warn "Unable to connect with Chargify, will ignore: #{e}"
          customer
        end
      end

=begin
      # Used by the Checkout form object.
      def self.new_checkout(user = nil, shipping_address = nil)
        return nil if shipping_address.nil? or user.nil? or not user.is_a?(User)
        @user             = user
        @shipping_address = shipping_address
      end
=end

      def self.find_by_id(id)
        # Rails.logger.error "#in customer find_by(#{id}) - chargify site: #{::Chargify.site} - #{::Chargify::Base.site} - #{::Chargify.subdomain}"
        customer = ::Chargify::Customer.find(id)
      end

      def self.update(params = {})
        self.update_attributes(params)
        self.save
      end

    end
  end
end
