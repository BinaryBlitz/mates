require 'test_helper'

class FriendRequestsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:foo)
    @friend = users(:john)
  end

  test 'should get index' do
    get '/api/friend_requests', api_token: api_token

    assert_response :success
    assert_not_nil assigns(:incoming)
    assert_not_nil assigns(:outgoing)
  end

  test 'should create and accept friend request' do
    assert_difference('FriendRequest.count') do
      post '/api/friend_requests', api_token: api_token, friend_id: @friend.id
    end
    assert_response :created

    patch "/api/friend_requests/#{FriendRequest.last.id}", api_token: @friend.api_token
    assert_response :no_content
    assert @user.friends.include?(@friend)
    assert @friend.friends.include?(@user)
  end
end