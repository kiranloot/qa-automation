require_relative "admin_object"
class AdminPinsPage < AdminPage
  def initialize
    super
  end

  def click_import_codes
    find_link("Import Codes").click
    wait_for_ajax
  end

  def select_product(product)
    find("#product_id").click
    wait_for_ajax
    find("#product_id option", :text => product).click
  end

  def fill_in_month_year(monthyear)
    fill_in("month_year", :with => monthyear)
  end

  def fill_in_redeption_url(url)
    fill_in("redemption_url", :with => url)
  end

  def upload_file(file_path = '')
    attach_file('file', File.absolute_path(file_path))
  end

  def click_commit
    find_button('Import').click
  end
end
