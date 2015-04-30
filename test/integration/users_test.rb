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
    post '/api/users', user: {
      first_name: 'Foo',
      last_name: 'Bar',
      nickname: 'Foobar',
      password: 'foobar',
      password_confirmation: 'foobar'
    }
    assert_response :created
  end

  test 'should show user' do
    get "/api/users/#{@user.id}", api_token: api_token
    assert_response :success
  end

  test 'should update user' do
    patch "/api/users/#{@user.id}", api_token: api_token, user: {
      first_name: 'Foo',
      last_name: 'Bar',
      password: 'foobar',
      password_confirmation: 'foobar'
    }
    assert_response :success
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete "/api/users/#{@user.id}", api_token: @user.api_token
    end
    assert_response :success
  end

  test 'should authenticate by nickname' do
    post "/api/users/authenticate", nickname: @user.nickname, password: 'foobar'
    assert_response :success
    assert_not_nil json_response['api_token']
  end

  test 'should authorize users' do
    stranger = users(:john)

    patch "/api/users/#{@user.id}", api_token: stranger.api_token
    assert_response :unauthorized

    delete "/api/users/#{@user.id}", api_token: stranger.api_token
    assert_response :unauthorized
  end
end
