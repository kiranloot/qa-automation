require 'chargify_api_ares'
#Net::HTTP.http_logger_options = {:verbose => true}

module Local
  module Chargify
    class Subscription

      def initialize(params, user)
        @params           = params
        @billing_address  = params[:subscription][:billing_address_attributes]
        @shipping_address = params[:subscription][:shipping_address_attributes]
        @credit_card      = params[:subscription][:credit_card]
        @coupon_code      = params[:subscription][:coupon_code]
        @user             = user
      end

      def create
        begin
          subscription_hash = {
            customer_id:        @params[:customer_id],
            payment_profile_id: @params[:subscription][:payment_profile_id],
            product_handle:     @params[:plan],
            next_billing_at:    @params[:subscription][:next_billing_at],
            coupon_code:        @coupon_code,
            credit_card_attributes: {
              first_name:        @shipping_address[:first_name],
              last_name:         @shipping_address[:last_name],
              expiration_year:   @credit_card.try(:[], :expiration).try(:year),#@credit_card[:expiration].year,
              expiration_month:  @credit_card.try(:[], :expiration).try(:month),#@credit_card[:expiration].month,
              cvv:               @credit_card.try(:[], :cvv),
              full_number:       @credit_card.try(:[], :number),
              billing_address:   @billing_address[:line_1],
              billing_address_2: @billing_address[:line_2],
              billing_city:      @billing_address[:city],
              billing_state:     @billing_address[:state],
              billing_zip:       @billing_address[:zip],
              billing_country:   @billing_address[:country]
            },
            customer_attributes: {
              email:      @user.email,
              first_name: @shipping_address[:first_name],
              last_name:  @shipping_address[:last_name],
              address:    @shipping_address[:line_1],
              address_2:  @shipping_address[:line_2],
              city:       @shipping_address[:city],
              state:      @shipping_address[:state],
              zip:        @shipping_address[:zip],
              country:    @shipping_address[:country]
            }
          }

          chargify_subscription = ::Chargify::Subscription.create(subscription_hash)
          chargify_subscription
        rescue => e
          Rails.logger.warn "Unable to connect with Chargify, will ignore: #{e}"
          Airbrake.notify(
            :error_class      => "Chargify Subscription Creation Error:",
            :error_message    => "Failed to create subscription: #{e}",
            :backtrace        => $@,
            :environment_name => ENV['RAILS_ENV']
          )
          chargify_subscription
        end
      end

      def self.find_by_id(id)
        subscription = ::Chargify::Subscription.find(id)
      end

      def self.update(params= {})
        self.update_attributes(params)
        self.save
      end

    end
  end
end
