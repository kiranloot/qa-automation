require_relative "my_account_page_object"

class MyAccountMobilePage < MyAccountPage
  def initialize
    super
    @page_type = "my_account"
    setup
    grab_user_data
  end

  def select_shipping_state(sub_id, state)
    select "#{state}", :from => "shipping_address_state#{sub_id}"
    $test.user.ship_state = state
  end
end
