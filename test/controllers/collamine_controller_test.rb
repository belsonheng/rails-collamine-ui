require 'test_helper'

class CollamineControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
