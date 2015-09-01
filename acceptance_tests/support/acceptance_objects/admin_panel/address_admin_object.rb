require_relative "admin_object"
class AdminAddressPage < AdminPage
  def initialize
    super
  end

  def search_address_by_full_name(full_name)
    fl = full_name.split(" ")
    first = fl[0]
    last = fl[1]
    page.find('#q_first_name').set(first)
    page.find('#q_last_name').set(last)
    click_filter
    wait_for_ajax
  end

  def click_filter
    page.find_button('Filter').click
  end

  def address_info_displayed?(user)
    wait_for_ajax
    assert_text(user.bill_zip)
    assert_text(user.bill_street)
    assert_text(user.bill_city)
    assert_text(user.full_name)
    assert_text(user.country_code)
  end

end