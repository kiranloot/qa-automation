require 'test_helper'

class AboutUsControllerTest < ActionController::TestCase
  test "should get info" do
    get :info
    assert_response :success
  end

end
