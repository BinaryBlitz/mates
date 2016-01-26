require 'test_helper'

class FriendsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:foo)
    @friend = users(:john)
  end

  test 'should get index' do
    get '/api/friends.json', api_token: api_token
    assert_response :success
  end

  test 'destroy' do
    assert_difference('FriendRequest.count') do
      post '/api/friend_requests.json', api_token: api_token, friend_id: @friend.id
    end
    assert_response :created

    patch "/api/friend_requests/#{FriendRequest.last.id}", api_token: @friend.api_token
    assert_response :ok
    assert @user.friends.include?(@friend)
    assert @friend.friends.include?(@user)

    delete "/api/friends/#{@friend.id}", api_token: api_token
    assert_response :no_content
    refute @user.friends.include?(@friend)
    refute @friend.friends.include?(@user)
  end

  test 'authorization' do
    stranger = users(:baz)
    @user.friends << @friend

    assert_raise ActiveRecord::RecordNotFound do
      delete "/api/friends/#{@friend.id}", api_token: stranger.api_token
    end
  end
end
