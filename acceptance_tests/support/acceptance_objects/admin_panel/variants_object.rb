require_relative "admin_object"
class AdminVariantsPage < AdminPage
  include WaitForAjax
  def initialize
    super
  end

  def set_variant_inventory(product_id,inventory,available)
    find(:id, "variant_#{product_id}").find_link("Change Inventory").click
    fill_in("inventory_unit_total_available", :with => inventory)
    if available
      check("inventory_unit_in_stock")
    else
      uncheck("inventory_unit_in_stock")
    end
    find(:id, "inventory_unit_submit_action").click
    wait_for_ajax
  end

end
