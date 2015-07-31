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
    page.find('#admin_user_email')
    fill_in("admin_user_email", :with => email)
    fill_in("admin_user_password", :with => password)
    page.find_button('Login').click
    wait_for_ajax
  end

  def click_subscriptions
    page.find_link('Subscriptions').click
    wait_for_ajax
  end

  def click_variants
    page.find_link('Variants').click
    wait_for_ajax
  end

  def click_promotions
    page.find_link('Promotions').click
    wait_for_ajax
  end

  def click_affiliates
    page.find_link('Affiliates').click
    wait_for_ajax
  end

  def admin_log_out
    find_link("Logout").click
    wait_for_ajax
  end

end
