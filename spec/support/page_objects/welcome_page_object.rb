class WelcomePageObject
  include Capybara::DSL
  include RSpec::Matchers
  include Rails.application.routes.url_helpers

  def visit_page
    visit root_path
  end

  def close_newsletter_modal
    click_on 'X' if page.has_selector? 'button.wf-close'
  end

  def open_register_modal
    find('button.navbar-toggle').click if page.has_selector? 'button.navbar-toggle'
    click_on 'Log In', :match => :first
    find('#signin_modal').find_link('Join').click
  end

  def fill_in_new_account_info visitor
    find('#register_modal')
    find('#register_modal').fill_in 'new_user_email_modal', :with => visitor.email
    find('#register_modal').click_on 'Join'
    find('#register_modal').fill_in 'new_user_password_modal', :with => visitor.password
  end

  def click_create_account
    find('#register_modal').click_on 'create_account_modal'
  end

end