require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:party)
  end

  test 'should get index' do
    get "/api/events/#{@event.id}/comments", api_token: api_token
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test 'should post, update, delete comments' do
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
end
