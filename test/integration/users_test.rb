require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:foo)
  end

  test 'should create user' do
    post '/api/users', user: {
      first_name: 'Foo',
      last_name: 'Bar',
      email: 'foo1@bar.com',
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

  test 'update preferences' do
    assert_equal true, @user.preferences.notifications_friends
    patch "/api/users/#{@user.id}.json", api_token: api_token, user: {
      preference_attributes: { notifications_friends: false }
    }
    assert_equal false, @user.reload.preferences.notifications_friends
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete "/api/users/#{@user.id}", api_token: @user.api_token
    end
    assert_response :success
  end

  test 'should authenticate by email' do
    post '/api/users/authenticate', email: @user.email, password: 'foobar'
    assert_response :success
    assert_not_nil json_response[:api_token]
  end

  test 'should authorize users' do
    stranger = users(:john)

    patch "/api/users/#{@user.id}", api_token: stranger.api_token
    assert_response :forbidden

    delete "/api/users/#{@user.id}", api_token: stranger.api_token
    assert_response :forbidden
  end

  test "should get user's friends" do
    get "/api/users/#{@user.id}/friends", api_token: api_token
    assert_response :success
  end

  test "should get user's events" do
    get "/api/users/#{@user.id}/events", api_token: api_token
    assert_response :success
  end

  test 'should add users to favorites' do
    favorite = users(:baz)

    post "/api/users/#{favorite.id}/favorite", api_token: api_token
    assert_response :created
    assert @user.favorited_users.include?(favorite)

    delete "/api/users/#{favorite.id}/unfavorite", api_token: api_token
    assert_response :no_content
    refute @user.favorited_users.include?(favorite)
  end

  test 'should search users by name' do
    get '/api/users/search', api_token: api_token, name: @user.first_name
    assert_response :success
  end
end
