require 'test_helper'

class FriendRequestsControllerTest < ActionController::TestCase
  setup do
    @user = users(:foo)
    @friend = users(:john)
  end

  test 'should create friend request' do
    assert_difference('FriendRequest.count') do
      post :create, format: :json, api_token: api_token, friend_id: @friend.id
    end

    assert_response :created
  end

  test 'should get index' do
    get :index, format: :json, api_token: api_token

    assert_response :success
    assert_not_nil assigns(:incoming)
    assert_not_nil assigns(:outgoing)
  end

  test 'should accept friend request' do
    post :create, format: :json, api_token: api_token, friend_id: @friend.id
    patch :update, format: :json, api_token: @friend.api_token, id: FriendRequest.last

    assert_response :no_content
    assert @user.friends.include?(@friend)
    assert @friend.friends.include?(@user)
  end
end
