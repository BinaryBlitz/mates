require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:foo)
  end

  test 'should get index' do
    get :index, api_token: api_token, format: :json
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test 'should create user' do
    assert_difference('User.count') do
      post :create, format: :json, user: {
        first_name: @user.first_name + '1',
        last_name: @user.last_name + '1',
        nickname: @user.nickname + '1'
      }
    end

    assert_response :created
  end

  test 'should show user' do
    get :show, id: @user, api_token: api_token, format: :json
    assert_response :success
  end

  test 'should update user' do
    patch :update,
          id: @user, api_token: api_token, format: :json,
          user: { first_name: @user.first_name + '1', last_name: @user.last_name + '1' }
    assert_response :success
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user, api_token: api_token, format: :json
    end

    assert_response :success
  end
end
