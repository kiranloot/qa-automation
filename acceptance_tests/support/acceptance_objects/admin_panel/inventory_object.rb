require_relative "admin_object"
class AdminInventoryUnitsPage < AdminPage
  include WaitForAjax
  def initialize
    super
  end

  def get_total_available_units(unit_id)
    table_scan_for("#inventory_unit_#{unit_id}")

    needed_row = find(:css, "#inventory_unit_#{unit_id}")
    needed_row.find(:css, "td.col-total_available").text
  end

  def verify_inventory_count(db_result)
    expect(get_total_available_units(db_result['id'])).to eq(db_result['total_available'])
  end

end
