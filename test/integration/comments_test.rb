require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:party)
    @event.users << users(:foo)
    @comment = comments(:comment)
  end

  test 'list' do
    get "/api/events/#{@event.id}/comments.json", api_token: api_token
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test 'create' do
    assert_difference 'Comment.count' do
      post "/api/events/#{@event.id}/comments.json",
           api_token: api_token, comment: { content: "Comment" }
      assert_response :created
    end
    assert_equal "Comment", Comment.last.content
  end

  test 'update' do
    patch "/api/comments/#{@comment.id}.json", api_token: api_token, comment: {
      content: 'Updated'
    }
    assert_response :ok
    assert_equal 'Updated', Comment.last.content
  end

  test 'delete' do
    delete "/api/comments/#{@comment.id}.json", api_token: api_token
    assert_response :no_content
  end

  test 'should auhtorize users' do
    stranger = users(:baz)

    post "/api/events/#{@event.id}/comments.json",
         api_token: stranger.api_token, comment: { content: "Hello!" }
    assert_response :forbidden

    patch "/api/comments/#{@comment.id}.json", api_token: stranger.api_token
    assert_response :forbidden

    delete "/api/comments/#{@comment.id}.json", api_token: stranger.api_token
    assert_response :forbidden
  end
end
