# coding: utf-8
class Subscription
  module Shipment
    class ShipstationOrderNumberGenerator
      attr_reader :month_year, :country, :state, :membership_card, :shirt_size

      def initialize(dto)
        @month_year = dto.month_year
        @country = dto.country
        @state = dto.state
        @membership_card = dto.membership_card
        @shirt_size = dto.shirt_size
        @subscription_id = dto.subscription_id
      end

      def generate
        # need to respect the (updated per shipstation max) field limit of 50 in db
        number = "#{month_year}-#{shipstation_friendly_order_prefix_minus_month}#{@subscription_id}"[0...50]
        unless Rails.env == 'production'
          number = number.prepend('TEST-')[0...50]
        end
        number
      end

      private

        def shipstation_friendly_order_prefix_minus_month
          "#{order_type}-#{international_or_usa}-#{membership_card_str}-#{country_or_state}-#{shirt_size}-#{DateTime.now.strftime('%m%d%y')}-"
        end

        def order_type
          # After discussion with Khoa, all store orders will always send this
          'GNRC'
        end

        def international?
          country != 'US'
        end

        def international_or_usa
          international? ? 'INTL' : 'US'
        end

        def membership_card_str
          # YESMC, NOMC				(yes membership card or no membership card)
          #	- Membership card orders are once in a subscription’s lifespan, 3rd crate sent.
          #
          # after speaking w/ Khoa, this is the logic:
          # on their third SHIPMENT - period.  It's a YESMC
          #
          # this is flawed  - we differentiate by 'order.user', not subscription.user, so in a multi-sub order,
          # only one card will come through
          #
          # I making the decision to go with 3rd-ever crate for a particular *subscription*
          membership_card ? 'YESMC' : 'NOMC'
        end

        def country_or_state
          international? ? country : state
        end
    end
  end
end
