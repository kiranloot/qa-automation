require_relative "admin_object"
class AdminVariantsPage < AdminPage
  include WaitForAjax
  def initialize
    super
  end

  def get_total_available_units(unit_id)
    table_scan_for("#variant_#{unit_id}")

    needed_row = find(:css, "#variant_#{unit_id}")
    needed_row.find(:css, "td.col-total_available").text
  end

  def verify_inventory_count(db_result)
    expect(get_total_available_units(db_result['variant_id'])).to eq(db_result['total_available'])
  end

  def set_variant_inventory(product_id,inventory)
    while (!page.has_css?("#variant_#{product_id}"))
      find_link("Next ›").click
      wait_for_ajax
      #Test will bomb out if it can't find the Next Button
      #So this should not produce an infinate loop
    end
    find(:id, "variant_#{product_id}").find_link("Change Inventory").click
    fill_in("inventory_unit_total_available", :with => inventory)
    find(:id, "inventory_unit_submit_action").click
    wait_for_ajax
  end

end
