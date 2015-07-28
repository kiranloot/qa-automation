module SubscriptionWorkers
  class DecrementInventory
    include Sidekiq::Worker

    def perform(variant_id)
      variant   = Variant.find variant_id
      inventory = variant.inventory_unit

      update_inventory(inventory)
    end

    private
      def update_inventory(inventory)
        inventory.total_committed += 1
        inventory.in_stock = false if inventory_stock_limit_reached?(inventory)

        inventory.save!
      end

      def inventory_stock_limit_reached?(inventory)
        inventory.total_committed >= inventory.total_available
      end
  end
end
