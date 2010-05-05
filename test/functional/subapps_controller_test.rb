require 'test_helper'

class SubappsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subapps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subapp" do
    assert_difference('Subapp.count') do
      post :create, :subapp => { }
    end

    assert_redirected_to subapp_path(assigns(:subapp))
  end

  test "should show subapp" do
    get :show, :id => subapps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => subapps(:one).to_param
    assert_response :success
  end

  test "should update subapp" do
    put :update, :id => subapps(:one).to_param, :subapp => { }
    assert_redirected_to subapp_path(assigns(:subapp))
  end

  test "should destroy subapp" do
    assert_difference('Subapp.count', -1) do
      delete :destroy, :id => subapps(:one).to_param
    end

    assert_redirected_to subapps_path
  end
end
