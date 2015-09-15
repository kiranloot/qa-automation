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

  def search_address_by_line_1(line)
    page.find('#q_line_1').set(line)
    sleep(0.5)
    click_filter
    wait_for_ajax
  end

  def click_filter
    page.find_button('Filter').click
  end

  def address_info_displayed?(user)
    wait_for_ajax
    data = [user.bill_zip, user.bill_street, user.bill_city,
            user.full_name, user.country_code]
    all_data_present = nil

    data.each do |v|
      all_data_present = page.has_content?(v)
    end

    if !all_data_present
      click_next
      wait_for_ajax
      return address_info_displayed?(user)
    else
      all_data_present
    end

  end

  def pagination_available?
    page.find_link('Next ›').visible?
  end

  def click_next
    page.find_link('Next ›').click
  end

end