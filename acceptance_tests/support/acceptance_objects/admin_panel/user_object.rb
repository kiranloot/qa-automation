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
    #assert_text($test.user.shirt_size)
  end

  def fill_in_email
    new_email = '_updated_' + Faker::Internet.user_name + rand(999).to_s + '@mailinator.com'
    fill_in('user_email', :with => new_email)
    $test.user.email = new_email
  end

  def fill_in_password
    new_password = Faker::Internet.password
    fill_in('user_password', :with => new_password)
    fill_in('user_password_confirmation', :with => new_password)
    $test.user.password = new_password
  end

  def fill_in_full_name
    new_full_name = Faker::Name.name
    fill_in('user_full_name', :with => new_full_name)
    $test.user.full_name = new_full_name
  end

  def click_update_user
    find(:id, 'user_submit_action').click
    wait_for_ajax
    assert_text('Update successful')
  end

  def user_updated?
    assert_text($test.user.full_name)
    assert_text($test.user.email)
  end
end
