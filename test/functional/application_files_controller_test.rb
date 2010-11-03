require 'test_helper'

class ApplicationFilesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:application_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create application_file" do
    assert_difference('ApplicationFile.count') do
      post :create, :application_file => { }
    end

    assert_redirected_to application_file_path(assigns(:application_file))
  end

  test "should show application_file" do
    get :show, :id => application_files(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => application_files(:one).to_param
    assert_response :success
  end

  test "should update application_file" do
    put :update, :id => application_files(:one).to_param, :application_file => { }
    assert_redirected_to application_file_path(assigns(:application_file))
  end

  test "should destroy application_file" do
    assert_difference('ApplicationFile.count', -1) do
      delete :destroy, :id => application_files(:one).to_param
    end

    assert_redirected_to application_files_path
  end
end
