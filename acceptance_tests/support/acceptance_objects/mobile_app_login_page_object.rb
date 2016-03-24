require_relative 'mobile_app_page_object'
class MobileAppLoginPage < MobileAppPage
  def initialize
  end

  def click_create_free_account
    find("//UIAButton[contains(@name,'createacc BTN@3x')]").click
  end

  def click_login
    find("//UIAButton[contains(@name,'Login')]").click
  end

  def fill_in_register_email(email)
    find("//UIATextField").send_keys(email) 
    hide_keyboard
  end

  def fill_in_login_email(email)
    find("//UIAApplication[1]/UIAWindow[2]/UIATextField[1]").send_keys(email)
    hide_keyboard
  end

  def fill_in_login_password(password)
    find("//UIAApplication[1]/UIAWindow[2]/UIASecureTextField[1]").send_keys(password)
    hide_keyboard
  end

  def click_next
    find("//UIAButton[contains(@name, 'Next')]").click
  end

  def fill_in_first_name(name)
    find("//UIAApplication[1]/UIAWindow[2]/UIATextField[2]").send_keys(name)
    hide_keyboard
  end

  def fill_in_last_name(name)
    find("//UIAApplication[1]/UIAWindow[2]/UIATextField[3]").send_keys(name)
    hide_keyboard
  end

  def fill_in_username(name)
    find("//UIAApplication[1]/UIAWindow[2]/UIATextField[4]").send_keys(name)
    hide_keyboard
  end

  def fill_in_register_password(password)
    find("//UIAApplication[1]/UIAWindow[2]/UIASecureTextField[1]").send_keys(password)
    hide_keyboard
  end

  def click_create_account
    find("//UIAButton[contains(@name, 'Create Account')]").click
  end

  def click_sign_in
    find("//UIAButton[contains(@name, 'Sign In')]").click
  end
end
