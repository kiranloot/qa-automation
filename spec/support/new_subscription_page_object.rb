class NewSubscriptionPageObject
  include Capybara::DSL
  include RSpec::Matchers

  attr_accessor :shipping_address, :billing_address, :user, :shirt_size, :name

  def initialize args
    args = defaults.merge(args)
    @billing_address = args[:billing_address]
    @shipping_address = args[:shipping_address]
    @user = args[:user]
    @shirt_size = args[:shirt_size]
    remove_zopim_popup
  end

  def fill_in_account_info
    select2(shirt_size, { from: 'checkout_shirt_size' })
  end

  def fill_in_shipping_info
    fill_in 'checkout_shipping_address_first_name', with: user.full_name.split(' ').first
    fill_in 'checkout_shipping_address_last_name', with: user.full_name.split(' ')[1]
    fill_in 'checkout_shipping_address_line_1', with: shipping_address.line_1
    fill_in 'checkout_shipping_address_city', with: shipping_address.city
    fill_in 'checkout_shipping_address_zip', with: shipping_address.zip
    select2(shipping_address.state, { from: 'checkout_shipping_address_state'})
    # page.find_by_id('checkout_shipping_address_state').find("option[value='#{shipping_address.state}']").select_option
  end

  def fill_in_credit_card(opts={})
    credit_card = default_credit_card.merge(opts)

    fill_in 'checkout_billing_address_full_name', with: user.full_name
    fill_in 'checkout_credit_card_number', with: credit_card[:credit_card_number]
    select2(credit_card[:expiration_month], { from: 'checkout_credit_card_expiration_date_2i'})
    select2(credit_card[:expiration_year], { from: 'checkout_credit_card_expiration_date_1i'})
    fill_in 'checkout_credit_card_cvv', with: credit_card[:cvv]
  end

  def fill_in_billing_info
    fill_in 'checkout_billing_address_full_name', with: user.full_name
    fill_in 'checkout_billing_address_line_1', with: billing_address.line_1
    fill_in 'checkout_billing_address_city', with: billing_address.city
    fill_in 'checkout_billing_address_zip', with: billing_address.zip
    page.find_by_id('checkout_billing_address_state').find("option[value='#{billing_address.state}']").select_option
  end

  def select2(value, options={})
    s2c = first("#s2id_#{options[:from]}")
    (s2c.first(".select2-choice") || s2c.find(".select2-choices")).click

    find(:xpath, "//body").all("input.select2-input")[-1].set(value)
    page.execute_script(%|$("input.select2-input:visible").keyup();|)
    drop_container = ".select2-results"
    find(:xpath, "//body").all("#{drop_container} li", text: value)[-1].click
  end

  def click_subscribe
    click_button 'SUBSCRIBE'
  end

  def has_states?
    !find("option[value='#{shipping_address.state}']").nil?
  end

  def remove_zopim_popup
    page.execute_script("$('.zopim').remove()")
  end

  def defaults
    {
      billing_address: FactoryGirl.build(:billing_address),
      shipping_address: FactoryGirl.build(:shipping_address),
      user: FactoryGirl.build(:user, full_name: 'Jeffects Testcase'),
      shirt_size: "Mens - XL"
    }
  end

  def default_credit_card
    {
      credit_card_number: 1,
      expiration_month: 'December',
      expiration_year: '2024',
      cvv: 123
    }
  end

end