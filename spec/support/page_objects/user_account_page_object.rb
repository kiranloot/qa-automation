class UserAccountPageObject
  include Capybara::DSL
  include RSpec::Matchers
  include Rails.application.routes.url_helpers

  def visit_page
    VCR.use_cassette 'subscription/read', match_requests_on: [:method, :uri_ignoring_id] do
      visit user_accounts_path
    end
  end

  def view_subscriptions
    VCR.use_cassette 'subscription/read', match_requests_on: [:method, :uri_ignoring_id] do
      visit user_accounts_subscriptions_path
    end
  end

  def cancel_a_subscription sub_id
    VCR.use_cassette 'subscription/recurly/cancel_subscription_at_end_of_period_success' do
      sub_path = user_accounts_path(sub_id)
      cancel_sub_path = cancel_at_end_of_period_subscription_path(sub_id)

      # Make sure on current subscription
      view_subscriptions unless current_path == sub_path

      cancel_sub_page_path = cancellation_subscription_path(sub_id)
      click_link('Payment Method')
      find(:xpath, "//a[@href='#{cancel_sub_page_path}']").click
      find(:xpath, "//a[@href='#{cancel_sub_path}']").click

      if Capybara.current_driver == :selenium
        page.driver.browser.switch_to.alert.accept
      end
    end
  end

  def reactivate_a_subscription sub_id
    VCR.use_cassette 'subscription/reactivate_success', match_requests_on: [:method, :uri_ignoring_id], allow_playback_repeats: true do

      reactivate_sub_page_path = reactivation_subscription_path(sub_id)
      find(:xpath, "//a[@href='#{reactivate_sub_page_path}']").click
      click_button('Submit')
    end
  end

  def click_edit_email
    find(:xpath, "//a[@href='/users/edit']").click
  end

  def update_full_name name
    find(:xpath, "//a[@data-target='#namechange_modal']").click
    find('#namechange_modal').fill_in('user_full_name', with: name)
    find('#namechange_modal').click_button('Update')
  end

  def update_email_address email
    find(:xpath, "//a[@data-target='#emailchange_modal']").click
    find('#emailchange_modal').fill_in('user_email', with: email)
    find('#emailchange_modal').click_button('Update')
  end

  def update_password current_pw, new_pw
    find(:xpath, "//a[@data-target='#passwordchange_modal']").click
    find('#passwordchange_modal').fill_in('user_current_password', with: current_pw)
    find('#passwordchange_modal').fill_in('user_password', with: new_pw)
    find('#passwordchange_modal').fill_in('user_password_confirmation', with: new_pw)
    find('#passwordchange_modal').click_button('Update')
  end

end