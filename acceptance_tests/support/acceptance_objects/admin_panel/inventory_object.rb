require_relative "admin_object"
class AdminInventoryUnitsPage < AdminPage
  include WaitForAjax
  def initialize
    super
  end

  def get_total_available_units(unit_id)
    while (first("#inventory_unit_#{unit_id}", maximum: 1).nil?)
      find_link("Next ›").click
      wait_for_ajax
      #Test will bomb out if it can't find the Next Button
      #So this should not produce an infinate loop
    end
    needed_row = find(:css, "#inventory_unit_#{unit_id}")
    needed_row.find(:css, "td.col-total_available").text
  end

  def verify_inventory_count(db_result)
    expect(get_total_available_units(db_result['id'])).to eq(db_result['total_available'])
  end

end
