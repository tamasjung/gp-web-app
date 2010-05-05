require 'test_helper'

class LaunchesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:launches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create launch" do
    assert_difference('Launch.count') do
      post :create, :launch => { }
    end

    assert_redirected_to launch_path(assigns(:launch))
  end

  test "should show launch" do
    get :show, :id => launches(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => launches(:one).to_param
    assert_response :success
  end

  test "should update launch" do
    put :update, :id => launches(:one).to_param, :launch => { }
    assert_redirected_to launch_path(assigns(:launch))
  end

  test "should destroy launch" do
    assert_difference('Launch.count', -1) do
      delete :destroy, :id => launches(:one).to_param
    end

    assert_redirected_to launches_path
  end
end
