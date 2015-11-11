require_relative "page_object"

class SignupPage < Page
include Capybara::DSL

  def initialize
    super
    @page_type = "signup"
    setup
  end

  def pop_email(email)
    fill_in("new_user_email", :with => email)
  end

  def submit_signup
    click_button("CREATE ACCOUNT")
    wait_for_ajax
  end

  def pop_password(password)
    fill_in("new_user_password", :with => password)
  end

  def visit_page
    visit $env_base_url
    wait_for_ajax
    page.has_content?('Subscribe')
    first(:link, 'Subscribe').click
    click_link('1 month plan')
    $test.current_page = self
  end
  
  def signup_failed?
    if page.has_css?('input#new_user_password.title.modal-join.required.dianaTone.error') &&
        #new_user_password
        current_url == @base_url
      return true
    else
      return false
    end
  end
end
