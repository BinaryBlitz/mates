require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:foo)
  end

  test 'should create user' do
    post '/api/users.json', user: {
      first_name: 'Foo',
      last_name: 'Bar',
      phone_number: '+71112223344'
    }
    assert_response :created
  end

  test 'should show user' do
    get "/api/users/#{@user.id}.json", api_token: api_token
    assert_response :success
  end

  test 'should update user' do
    patch "/api/users/#{@user.id}.json", api_token: api_token, user: {
      first_name: 'Foo',
      last_name: 'Bar'
    }
    assert_response :ok
  end

  test 'update preferences' do
    assert_equal true, @user.preferences.notifications_friends
    patch "/api/users/#{@user.id}.json", api_token: api_token, user: {
      preference_attributes: { notifications_friends: false }
    }
    assert_equal false, @user.reload.preferences.notifications_friends
  end

  test 'update interests' do
    assert_difference '@user.interests.count' do
      patch "/api/users/#{@user.id}.json", api_token: @user.api_token, user: {
        interests_attributes: [ { category_id: categories(:cafe).id } ]
      }
    end
    assert_response :ok
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete "/api/users/#{@user.id}.json", api_token: @user.api_token
    end
    assert_response :success
  end

  test 'should authorize users' do
    stranger = users(:john)

    patch "/api/users/#{@user.id}.json", api_token: stranger.api_token
    assert_response :forbidden

    delete "/api/users/#{@user.id}.json", api_token: stranger.api_token
    assert_response :forbidden
  end

  test "should get user's friends" do
    get "/api/users/#{@user.id}/friends.json", api_token: api_token
    assert_response :success
  end

  test "user's memberships" do
    get "/api/users/#{@user.id}/memberships.json", api_token: api_token
    assert_response :success
  end

  test 'should search users by name' do
    get '/api/users/search.json', api_token: api_token, name: @user.first_name
    assert_response :success
  end
end
