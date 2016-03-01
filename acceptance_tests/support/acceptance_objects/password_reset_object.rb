require_relative "page_object"

class PasswordResetPage < Page
include Capybara::DSL

  def initialize
  end

  def reset_password(password)
    fill_in("user_password", :with => password)
    fill_in("user_password_confirmation", :with => password)
    find(:id, "change-my-password-btn").click
    wait_for_ajax
    find("#message-close-lnk").click
    wait_for_ajax
    $test.user.password = password
  end

  def submit_signup
    click_button("CREATE YOUR ACCOUNT")
    wait_for_ajax
  end

  def pop_password(password)
    fill_in("new_user_password", :with => password)
  end

  #def visit_page
  #  visit $env_base_url
  #  wait_for_ajax
  #  page.has_content?('Subscribe')
  #  first(:link, 'Subscribe').click
  #  wait_for_ajax
#    find(:id, 'one-month').click
  #  $test.current_page = self
  #end

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
