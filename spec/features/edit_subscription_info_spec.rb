feature 'Edit Subscription info' do

  given(:subscription) do
    create(:subscription,
      subscription_periods: [build(:active_subscription_period)])
  end
  given(:user) { create(:user, subscriptions: [subscription]) }
  given(:subscription_page) { SubscriptionPageObject.new }
  given(:new_address) { FactoryGirl.build(:billing_address) }
  given(:new_credit_card) { CreditCard.new(number: 2, cvv: 123, expiration:Date.new(2025,1,1)) }

  background do
    login_as user, scope: :user
    allow_any_instance_of(User).to receive(:sync_subscriptions!).and_return(nil)
    subscription_page.visit_page
  end

  scenario 'updating subscription name', js: true do
    subscription_page.click_edit(:subscription_name, subscription)
    subscription_page.update_subscription_name('Test')
    subscription_page.click_update

    expect(page).to have_content('LOOTER INFO')
    expect(page).to have_content('Test')
  end

  scenario 'updating shirt', js: true do
    subscription_page.click_edit(:shirt_size, subscription)
    subscription_page.update_shirt_size('Mens - L')
    subscription_page.click_update

    expect(page).to have_content('LOOTER INFO')
    expect(page).to have_content('M L')
  end

  scenario 'updating payment method', js: true do
    VCR.use_cassette 'subscription/update_payment_info', match_requests_on: [:method, :uri_ignoring_id] do
      subscription_page.click_edit(:payment_info, subscription)
      subscription_page.update_payment_info(new_credit_card, new_address)
      subscription_page.click_update

      expect(page).to have_content('PAYMENT METHOD')
      expect(page).to have_content(new_address.full_name)
    end
  end

  scenario 'updating billing address', js: true do
    VCR.use_cassette 'subscription/update_payment_info', match_requests_on: [:method, :uri_ignoring_id] do
      subscription_page.click_edit(:billing_address, subscription)
      subscription_page.update_billing_info(new_address)
      subscription_page.click_update

      expect(page).to have_content('BILLING ADDRESS')
      expect(page).to have_content(new_address.line_1)
      expect(page).to have_content(new_address.line_2)
      expect(page).to have_content(new_address.city)
      expect(page).to have_content(new_address.state)
      expect(page).to have_content(new_address.zip)
      expect(page).to have_content(new_address.country)
    end
  end

  scenario 'updating shipping address', js: true do
    VCR.use_cassette 'subscription/update_shipping_info', match_requests_on: [:method, :uri_ignoring_id], allow_playback_repeats: true do
      subscription_page.click_edit(:shipping_address, subscription)
      subscription_page.update_shipping_info(new_address)
      subscription_page.click_update

      expect(page).to have_content('SHIPPING ADDRESS')
      expect(page).to have_content(new_address.line_1)
      expect(page).to have_content(new_address.line_2)
      expect(page).to have_content(new_address.city)
      expect(page).to have_content(new_address.state)
      expect(page).to have_content(new_address.zip)
      expect(page).to have_content(new_address.country)
    end
  end
end
