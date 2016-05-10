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

  def select_billing_state(sub_id, state)
    select "#{state}", :from => "payment_method_state#{sub_id}"
    $test.user.billing_address.state = state
  end

  def select_shirt_size(sub_id, size)
    select "#{size}", :from => 'subscription_subscription_variants_attributes_0_variant_id'
    $test.user.subscription.sizes[:shirt] = size
  end
end
