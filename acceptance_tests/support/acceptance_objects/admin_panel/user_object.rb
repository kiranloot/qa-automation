require_relative "admin_object"
class AdminUsersPage < AdminPage
  def initialize
    super
  end

  def filter_for_user
    fill_in('#q_email', :with => $test.user.email)
    find(:css, 'input.commit').click
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
end
