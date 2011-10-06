require 'test_helper'

class Member::DashboardsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

end
