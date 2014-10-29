require 'test_helper'

class FileOperationsControllerTest < ActionController::TestCase
  setup do
    @file_operation = file_operations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:file_operations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create file_operation" do
    assert_difference('FileOperation.count') do
      post :create, file_operation: { file_path: @file_operation.file_path, info: @file_operation.info, job_class: @file_operation.job_class, status: @file_operation.status, user_id: @file_operation.user_id, user_type: @file_operation.user_type }
    end

    assert_redirected_to file_operation_path(assigns(:file_operation))
  end

  test "should show file_operation" do
    get :show, id: @file_operation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @file_operation
    assert_response :success
  end

  test "should update file_operation" do
    patch :update, id: @file_operation, file_operation: { file_path: @file_operation.file_path, info: @file_operation.info, job_class: @file_operation.job_class, status: @file_operation.status, user_id: @file_operation.user_id, user_type: @file_operation.user_type }
    assert_redirected_to file_operation_path(assigns(:file_operation))
  end

  test "should destroy file_operation" do
    assert_difference('FileOperation.count', -1) do
      delete :destroy, id: @file_operation
    end

    assert_redirected_to file_operations_path
  end
end
