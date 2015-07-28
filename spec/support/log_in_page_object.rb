class LoginPageObject
  include Capybara::DSL
  include RSpec::Matchers
  include Rails.application.routes.url_helpers

  attr_reader :base_uri

  def initialize args={}
    if args[:base_uri]
      @base_uri = args[:base_uri]
    else
      @base_uri = '/'
    end
  end

  def visit_page
    visit "#{base_uri}/users/sign_up"
  end

  # TODO move out of this page
  def visit_join_page
    visit "#{base_uri}/join"
  end

  def click_one_month
    click_link('one-month')
  end

  def register user
    fill_in('new_user_email', with: user.email)
    fill_in('new_user_password', with: user.password)
    click_button 'CREATE ACCOUNT'
  end

  def log_in user
    visit user_session_path if current_path != user_session_path

    VCR.use_cassette 'subscription/read', match_requests_on: [:method, :uri_ignoring_id] do
      within '.existing-customer' do
        fill_in('user_email', with: user.email)
        fill_in('user_password', with: user.password)
        click_button 'LOG IN'
      end
    end
  end

  def show_login_modal
    page.execute_script("$('.dropdown .login').click()")
  end
end
