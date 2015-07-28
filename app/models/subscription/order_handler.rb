class Subscription
  class OrderHandler
    attr_accessor :month_year

    def initialize(month_year)
      @month_year = month_year
    end

    def handle_domestic_orders
      Subscription.active.domestic.find_in_batches do |batch|
        handle_orders(batch)
      end
    end

    def handle_international_orders
      Subscription.active.international.find_in_batches do |batch|
        handle_orders(batch)
      end
    end

    def handle_all_orders
      Subscription.active.find_in_batches do |batch|
        handle_orders(batch)
      end
    end

    def force_subscription(id)
      subscription = Subscription.find id
      subscription_period = subscription.current_period

      subscription_period.subscription_units.where(month_year: @month_year).each(&:destroy)

      push_to_wombat([subscription_period.subscription_units.create!(
        month_year: @month_year,
        shirt_size: subscription.shirt_size.gsub(/ /, ''),
        netsuite_sku: sku_for_shirt_size(subscription.shirt_size),
        shipping_address: subscription.shipping_address.clone,
        status: 'awaiting_shipment')]
      )
    end

    def twentieth_of_crate_month
      @twentieth_of_crate_month ||= Date.strptime("#{@month_year[0..2]}/20/#{@month_year[3..-1]}", '%b/%d/%Y').change(offset: '-0500')
    end

    private

      def handle_orders(batch)
        batch_to_wombat = []

        batch.each do |subscription|
          next unless subscription_is_shippable?(subscription)

          subscription_period = subscription.current_period

          begin
            batch_to_wombat << subscription_period.subscription_units.create!(
              month_year: @month_year,
              shirt_size: subscription.shirt_size.gsub(/ /, ''),
              netsuite_sku: sku_for_shirt_size(subscription.shirt_size),
              shipping_address: subscription.shipping_address.clone,
              status: 'awaiting_shipment'
            )
          rescue => e
            Rails.logger.info "Failed to create subscription_unit for #{subscription.id}. Reason: #{e.message}"
          end
        end

        # wombat will only allow 100 at a time
        batch_to_wombat.each_slice(100) do |slice|
          push_to_wombat(slice)
        end
      end

      def push_to_wombat(batch)
        Wombat::Pusher.push(ActiveModel::ArraySerializer.new(
          batch,
          each_serializer: Wombat::SubscriptionShipmentSerializer,
          root: 'shipment'
        ).to_json)
      end

      def sku_for_shirt_size(shirt_size)
        "#{month_year}-#{ shirt_size.gsub(/ /, '') }"
      end

      def record_error(message, options = {})
        SubscriptionOrderHandlerError.create(
          message: message,
          status: 'new',
          sub_id: options[:sub_id],
          sub_shirt_size: options[:shirt_size]
        )
      end

      def subscription_is_shippable?(subscription)
        paid_for_current_crate_month?(subscription) && !skipped?(subscription)
      end

      def paid_for_current_crate_month?(subscription)
        subscription.next_assessment_at &&
        subscription.next_assessment_at > DateTime.now &&
        subscription.next_assessment_at >= twentieth_of_crate_month
      end

      def skipped?(subscription)
        SubscriptionSkippedMonth.where(
          subscription_id: subscription.id,
          month_year: Subscription::CrateDateCalculator.current_crate_month_year
        ).present?
      end
  end
end
