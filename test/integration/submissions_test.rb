require 'test_helper'

class SubmissionsTest < ActionDispatch::IntegrationTest
  setup do
    @guest = users(:baz)
    @event = events(:party)
  end

  test 'list' do
    get "/api/events/#{@event.id}/submissions.json", api_token: @event.creator.api_token
    assert_response :success
  end

  test 'cannot submit with invalid age or gender' do
    @guest.update!(birthday: 15.years.ago)
    post "/api/events/#{@event.id}/submissions.json", api_token: @guest.api_token
    assert_response 422
  end

  test 'create with valid age' do
    post "/api/events/#{@event.id}/submissions.json", api_token: @guest.api_token
    assert_response :created
  end

  test 'accept' do
    submission = @guest.submissions.create!(event: @event)
    patch "/api/submissions/#{submission.id}", api_token: @event.creator.api_token
    assert_response :no_content
  end

  test 'decline' do
    submission = @guest.submissions.create!(event: @event)
    patch "/api/submissions/#{submission.id}/decline", api_token: @event.creator.api_token
    assert_response :ok
  end

  test 'cancel' do
    submission = @guest.submissions.create!(event: @event)
    delete "/api/submissions/#{submission.id}", api_token: submission.user.api_token
    assert_response :no_content
  end

  test 'authorizarion' do
    stranger = users(:baz)
    get "/api/events/#{@event.id}/submissions.json", api_token: stranger.api_token
    assert_response :forbidden
  end
end
