class Subscription
  module Shipment
    class WeightThresholdLookup
      def initialize(shipment)
        @shipment = shipment
      end

      def weight_over_threshold?
        threshold = ZoneSkippingThreshold.find_by_month_year_shirt_size(
          "#{@shipment.month_year}#{@shipment.shirt_size}"
        )
        threshold.present? && threshold.over_threshold?
      end
    end
  end
end
