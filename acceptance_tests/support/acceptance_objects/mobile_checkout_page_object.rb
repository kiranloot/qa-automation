require_relative "checkout_page_object"

class MobileCheckoutPage < CheckoutPage

  def initialze
    super
    @page_type = "lootcrate_checkout"
    setup
  end

  def select_shirt_size(size)
    select "#{size}", :from => "option_type_shirt"
  end

  def select_shipping_state(state)
    select "#{state}", :from => "checkout_shipping_address_state"
  end

  def select_cc_exp_month(month)
    select "#{month}", :from => "checkout_credit_card_expiration_date_2i"
  end

  def select_cc_exp_year(year)
    select "#{year}", :from => "checkout_credit_card_expiration_date_1i"
  end 
end
