require_relative "page_object"

class SignupPage < Page
include Capybara::DSL

  def initialize
    super
    @page_type = "signup"
    #additional lines to check for during the segment tests
    @tracking_script_lines << "lca.page('registrations', 'new', '');"
    @tracking_script_lines << "lca.clickTracking();"
    setup
  end

  def click_new_customer_toggle
    sleep(1)
    find(:css, '#new-customer-container span.goOrange').click
    wait_for_ajax
  end

  def log_in_or_register
    if $test.db.user_exists?($test.user.email)
      click_new_customer_toggle
      enter_login_info($test.user)
    else
      enter_register_info($test.user)
    end
    wait_for_ajax
  end

  def enter_register_info(user)
    wait_for_ajax
    enter_new_email(user.email)
    enter_new_password(user.password)
    submit_signup
  end

  def enter_login_info(user)
    wait_for_ajax
    enter_login_email(user.email)
    enter_login_password(user.password)
    submit_login
  end

  def enter_new_email(email)
    fill_in("new_user_email", :with => email)
  end

  def enter_new_password(password)
    fill_in("new_user_password", :with => password)
  end

  def enter_login_email(email)
    fill_in("user_email", :with => email)
  end

  def enter_login_password(email)
    fill_in("user_password", :with => email)
  end

  def submit_signup
    click_button("CREATE YOUR ACCOUNT")
    page.has_css?("#one-month")
  end

  def submit_login
    click_button("Log In")
    page.has_css?("#one-month")
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
