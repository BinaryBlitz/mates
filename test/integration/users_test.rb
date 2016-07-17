require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:foo)
  end

  test 'should create user' do
    user_attributes = %w(first_name last_name phone_number)
    post api_users_path, params: { user: @user.attributes.slice(*user_attributes) }
    assert_response :created
  end

  test 'should show user' do
    get api_user_path(@user, api_token: api_token)
    assert_response :success
  end

  test 'should update user' do
    patch api_user_path(@user, api_token: api_token), params: {
      user: { first_name: 'Foo', last_name: 'Bar' }
    }
    assert_response :ok
  end

  test 'update preferences' do
    assert_equal true, @user.notifications_friends
    patch api_user_path(@user, api_token: api_token), params: {
      user: { notifications_friends: false }
    }
    assert_equal false, @user.reload.notifications_friends
  end

  test 'update interests' do
    assert_difference '@user.interests.count' do
      patch api_user_path(@user, api_token: @user.api_token), params: {
        user: { interests_attributes: [ { category_id: categories(:cafe).id } ] }
      }
    end
    assert_response :ok
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete api_user_path(@user, api_token: @user.api_token)
    end
    assert_response :success
  end

  test 'should authorize users' do
    stranger = users(:john)

    patch api_user_path(@user, api_token: stranger.api_token)
    assert_response :forbidden

    delete api_user_path(@user, api_token: stranger.api_token)
    assert_response :forbidden
  end

  test "should get user's friends" do
    get friends_api_user_path(@user, api_token: api_token)
    assert_response :success
  end

  test "user's memberships" do
    get api_user_memberships_path(@user, api_token: api_token)
    assert_response :success
  end

  test 'should search users by name' do
    get search_api_users_path(api_token: api_token), params: { name: @user.first_name }
    assert_response :success
  end
end
