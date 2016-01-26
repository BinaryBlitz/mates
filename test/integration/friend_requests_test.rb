require 'test_helper'

class FriendRequestsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:foo)
    @friend = users(:john)
  end

  test 'should get index' do
    get '/api/friend_requests.json', api_token: api_token

    assert_response :success
    assert_not_nil json_response[:incoming]
    assert_not_nil json_response[:outgoing]
  end

  test 'create' do
    assert_difference('FriendRequest.count') do
      post '/api/friend_requests.json', api_token: api_token, friend_id: @friend.id
    end
    assert_response :created
  end

  test 'accept' do
    friend_request = @user.friend_requests.create!(friend: @friend)

    patch "/api/friend_requests/#{friend_request.id}", api_token: @friend.api_token
    assert_response :ok

    assert @user.friends.include?(@friend)
    assert @friend.friends.include?(@user)
  end

  test 'decline' do
    friend_request = @user.friend_requests.create!(friend: @friend)
    patch "/api/friend_requests/#{friend_request.id}/decline.json", api_token: @friend.api_token
    assert_response :ok
  end

  test 'cancel' do
    friend_request = @user.friend_requests.create!(friend: @friend)
    delete "/api/friend_requests/#{friend_request.id}.json", api_token: @user.api_token
    assert_response :no_content
  end

  test 'authorization' do
    stranger = users(:baz)
    friend_request = @user.friend_requests.create(friend: @friend)

    patch "/api/friend_requests/#{friend_request.id}", api_token: stranger.api_token
    assert_response :forbidden

    delete "/api/friend_requests/#{friend_request.id}", api_token: stranger.api_token
    assert_response :forbidden
  end
end
