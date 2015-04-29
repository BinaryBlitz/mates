require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:foo)
  end

  test "index" do
    get '/api/users/', api_token: api_token
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test 'should create user' do
    assert_difference('User.count') do
      post '/api/users', user: {
        first_name: @user.first_name + '1',
        last_name: @user.last_name + '1',
        nickname: @user.nickname + '1'
      }
    end

    assert_response :created
  end

  test 'should show user' do
    get "/api/users/#{@user.id}", api_token: api_token
    assert_response :success
  end

  test 'should update user' do
    patch "/api/users/#{@user.id}", api_token: api_token,
          user: { first_name: @user.first_name + '1', last_name: @user.last_name + '1' }
    assert_response :success
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete "/api/users/#{@user.id}", api_token: api_token
    end

    assert_response :success
  end
end
