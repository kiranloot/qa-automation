require_relative "../page_object"
#Super class containing nav links
#Other Admin classes can inherit from this
class AdminPage < Page
  def initialize
    super
    @page_type = 'admin'
    setup
  end

  def admin_login(email, password)
    if page.has_css?('#admin_user_email')
      fill_in("admin_user_email", :with => email)
      fill_in("admin_user_password", :with => password)
      find_button('Login').click
    end
    wait_for_ajax
  end

  def click_users
    find_link('Users').click
    wait_for_ajax
  end

  def click_subscriptions
    find_link('Subscriptions').click
    wait_for_ajax
  end

  def click_variants
    find_link('Variants').click
    wait_for_ajax
  end

  def click_promotions
    find_link('Promotions').click
    wait_for_ajax
  end

  def click_affiliates
    find_link('Affiliates').click
    wait_for_ajax
  end

  def click_addresses
    find_link("More").hover
    find_link("Addresses").click
    wait_for_ajax
  end

  def admin_log_out
    find_link("Logout").click
    wait_for_ajax
  end

  def click_more
    find_link("More").click
    wait_for_ajax
  end

  def click_shipping_manifests
    click_more
    find_link("Shipping Manifests").click
    wait_for_ajax
  end

  def click_inventory_units
    find_link("Inventory Units").click
    wait_for_ajax
  end

  def table_scan_for(target_element)
    while (first(target_element, maximum: 1).nil?)
      find_link("Next ›").click
      wait_for_ajax
    end
  end
end
