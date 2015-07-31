require_relative "admin_object"
class AdminUsersPage < AdminPage
  def initialize
    super
  end

  def filter_for_user
    admin = $test.user
    find('#q_email').set(admin.subject_user.email)
    find_button('Filter').click
    wait_for_ajax
  end

  def view_user
    filter_for_user
    find_link('View').click
    wait_for_ajax
  end

  def edit_user
    filter_for_user
    find_link('Edit').click
    wait_for_ajax
  end

  def user_information_displayed?
    $test.set_subject_user
    assert_text("User Details")
    assert_text($test.user.email)
    #TO DO: need to add another display variable
    #this is displayed differently in the user page
    #assert_text($test.user.subscription_name.downcase)
    assert_text($test.user.shirt_size)
  end
end
