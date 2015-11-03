require_relative "page_object"
require "capybara/cucumber"
require "pry"
  
class Mailinator < Page
  include Capybara::DSL
  def initialize
    super
    @env ||= :qa
    @page_type = "mailinator"
    setup
  end

  def email_log_in(em)
    wait_for_ajax
    page.find("#inboxfield")
    fill_in("inboxfield", :with => em)
    page.click_button("Go!")
    wait_for_ajax
  end

  def find_reset_email
    tolerance = 3
    for i in 0..tolerance
      if page.has_content?("Reset Password Instructions")
        page.has_content?("Reset Password Instructions")
        find('.subject.ng-binding', :text => "Reset Password Instructions").click
        break
      else
        visit current_url
      end
    end
  end

  def reset_password_from_email
    email_log_in($test.user.email)
    find_reset_email
    page.has_content?("RESET PASSWORD")
    list = page.all(:css, 'a')
    list.each  do |element|
      if element.text.include?("Remove Safety Filter")
        element.click
      end
    end
    second_list = page.all()
    second_list.each do |element|
      puts element.text
    end
    #Click the reset password link. Haven't been able to make this work. 
    page.has_content?("LootCrate")
    find_field("user_password")
    fill_in("user_password", :with => $test.user.password)
    fill_in("user_password_confirmation", :with => $test.user.password)
  end
end 
