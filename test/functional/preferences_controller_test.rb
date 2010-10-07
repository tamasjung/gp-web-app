require 'test_helper'

class PreferencesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:preferences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create preference" do
    assert_difference('Preference.count') do
      post :create, :preference => { }
    end

    assert_redirected_to preference_path(assigns(:preference))
  end

  test "should show preference" do
    get :show, :id => preferences(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => preferences(:one).to_param
    assert_response :success
  end

  test "should update preference" do
    put :update, :id => preferences(:one).to_param, :preference => { }
    assert_redirected_to preference_path(assigns(:preference))
  end

  test "should destroy preference" do
    assert_difference('Preference.count', -1) do
      delete :destroy, :id => preferences(:one).to_param
    end

    assert_redirected_to preferences_path
  end
end
