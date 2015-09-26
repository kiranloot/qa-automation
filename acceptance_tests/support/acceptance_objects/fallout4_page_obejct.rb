require_relative "page_object"

class Fallout4Page < Page
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "fallout4"
    setup
  end

  def register_for_fallout4
    fill_in('new_user_email', :with => $test.user.email)
    fill_in('new_user_password', :with => $test.user.password)
    find_button('CREATE ACCOUNT').click
  end

  def click_buy_now
    find_link("Buy Now").click
    wait_for_ajax
  end

  def submit_valid_fallout4_information
    $test.user.shirt_size = 'Unisex - M'
    $test.user.enter_shirt_size
    $test.user.enter_first_and_last
    $test.user.submit_credit_card_information
    $test.user.enter_shipping_info
    click_button('checkout')
    wait_for_ajax
  end

  def fallout4_confirmation_displayed?
    assert_text('ORDER SUCCESSFUL')
    assert_text('Congratulations Vault Dweller')
  end
end
