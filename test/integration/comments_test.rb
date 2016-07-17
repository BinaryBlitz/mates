require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:party)
    @event.users << users(:foo)
    @comment = comments(:comment)
  end

  test 'list' do
    get api_event_comments_path(@event, api_token: api_token)
    assert_response :success
  end

  test 'create' do
    assert_difference 'Comment.count' do
      post api_event_comments_path(@event, api_token: api_token), params: {
        comment: { content: "Comment" }
      }
    end
    assert_response :created
    assert_equal "Comment", Comment.last.content
  end

  test 'update' do
    patch api_comment_path(@comment, api_token: api_token), params: {
      comment: { content: 'Updated' }
    }
    assert_response :ok
    assert_equal 'Updated', Comment.last.content
  end

  test 'delete' do
    delete api_comment_path(@comment, api_token: api_token)
    assert_response :no_content
  end

  test 'should auhtorize users' do
    stranger = users(:baz)

    post api_event_comments_path(@event, api_token: stranger.api_token), params: {
      comment: { content: "Hello!" }
    }
    assert_response :forbidden

    patch api_comment_path(@comment, api_token: stranger.api_token)
    assert_response :forbidden

    delete api_comment_path(@comment, api_token: stranger.api_token)
    assert_response :forbidden
  end
end
