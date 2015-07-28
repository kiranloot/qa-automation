class SubscriptionPageObject
  include Capybara::DSL
  include RSpec::Matchers
  include Rails.application.routes.url_helpers

  def visit_page
    visit user_accounts_subscriptions_path
  end

  def click_edit(field, subscription)
    case field
    when :shirt_size
      click_link("edit-heading-one#{subscription.id}")
      click_link('Edit')
    when :subscription_name
      click_link("edit-heading-one#{subscription.id}")
      click_link('Edit')
    when :payment_info
      click_link('Payment Method')
      expect(page).to have_content('Name on Card')
      click_link("edit-heading-two#{subscription.id}")
      click_link('Edit')
    when :billing_address
      click_link('Billing Address')
      expect(page).to have_content('Address Line 1')
      click_link("edit-heading-three#{subscription.id}")
      click_link('Edit')
    when :shipping_address
      click_link('Shipping Address')
      expect(page).to have_content('Address Line 1')
      click_link("edit-heading-four#{subscription.id}")
      click_link('Edit')
    end
  end

  def click_update
    click_button('Update')
  end

  def click_upgrade
    VCR.use_cassette 'subscription/get_upgrade_preview', match_requests_on: [:method, :uri_ignoring_id] do
      click_link 'Upgrade'
    end
  end

  def click_upgrade_submit
    VCR.use_cassette 'subscription/upgrade_success', match_requests_on: [:method, :uri_ignoring_id] do
      click_button 'upgrade-button'
    end
  end

  def update_shirt_size(size)
    fill_in('subscription_name', with: 'Test')
    find('#s2id_subscription_shirt_size').click
    find('.select2-result-label', text: size).click
  end

  def update_subscription_name(name)
    fill_in('subscription_name', with: name)
    find('#s2id_subscription_shirt_size').click
    find('.select2-result-label', text: 'Mens - L').click
  end

  def update_payment_info(cc, billing_address)
    fill_in('billing_address_full_name', with: billing_address.full_name)
    fill_in('billing_address_credit_card_number', with: cc.number)
    fill_in('billing_address_credit_card_cvv', with: cc.cvv)
    find('#s2id_billing_address_credit_card_expiration_2i').click
    find('.select2-result-label', text: Date.today.strftime('%B')).click
    find('#s2id_billing_address_credit_card_expiration_1i').click
    find('.select2-result-label', text: Date.today.year).click
  end

  def update_billing_info(billing_address)
    fill_in('billing_address_credit_card_number', with: '4111111111111111')
    fill_in('billing_address_line_1', with: billing_address.line_1)
    fill_in('billing_address_line_2', with: billing_address.line_2)
    fill_in('billing_address_city', with: billing_address.city)
    fill_in('billing_address_zip', with: billing_address.zip)
    find('#s2id_billing_address_state').click
    find('.select2-result-label', text: billing_address.state).click
  end

  def update_shipping_info(address)
    fill_in('shipping_address_first_name', with: address.first_name)
    fill_in('shipping_address_last_name', with: address.last_name)
    fill_in('shipping_address_line_1', with: address.line_1)
    fill_in('shipping_address_line_2', with: address.line_2)
    fill_in('shipping_address_city', with: address.city)
    fill_in('shipping_address_zip', with: address.zip)
    find('#s2id_shipping_address_state').click
    find('.select2-result-label', text: address.state).click
  end
end
