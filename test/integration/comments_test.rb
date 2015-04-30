require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:party)
    @comment = comments(:comment)
  end

  test 'should get index' do
    get "/api/events/#{@event.id}/comments", api_token: api_token
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test 'should post, update, delete comments' do
    # Allow the user to post comments on event
    @event.users << users(:foo)

    post "/api/events/#{@event.id}/comments", api_token: api_token, comment: {
      content: "comment"
    }
    assert_response :created
    assert_equal "comment", Comment.last.content

    patch "/api/events/#{@event.id}/comments/#{Comment.last.id}", api_token: api_token, comment: {
      content: "updated"
    }
    assert_response :ok
    assert_equal "updated", Comment.last.content

    delete "/api/events/#{@event.id}/comments/#{Comment.last.id}", api_token: api_token
    assert_response :no_content
  end

  test 'should auhtorize users' do
    stranger = users(:baz)

    post "/api/events/#{@event.id}/comments", api_token: stranger.api_token, comment: {
      content: "Hello!"
    }
    assert_response :unauthorized

    patch "/api/events/#{@event.id}/comments/#{@comment.id}", api_token: stranger.api_token
    assert_response :unauthorized

    delete "/api/events/#{@event.id}/comments/#{@comment.id}", api_token: stranger.api_token
    assert_response :unauthorized
  end
end
