require 'test_helper'

class SubmissionsTest < ActionDispatch::IntegrationTest
  setup do
    @guest = users(:baz)
    @event = events(:party)
  end

  test 'list' do
    get api_event_submissions_path(@event, api_token: @event.creator.api_token)
    assert_response :success
  end

  test 'create with valid age' do
    post api_event_submissions_path(@event, api_token: @guest.api_token)
    assert_response :created
  end

  test 'accept' do
    submission = @guest.submissions.create!(event: @event)
    patch api_submission_path(submission, api_token: @event.creator.api_token)
    assert_response :no_content
  end

  test 'decline' do
    submission = @guest.submissions.create!(event: @event)
    patch decline_api_submission_path(submission, api_token: @event.creator.api_token)
    assert_response :ok
  end

  test 'cancel' do
    submission = @guest.submissions.create!(event: @event)
    delete api_submission_path(submission, api_token: submission.user.api_token)
    assert_response :no_content
  end

  test 'authorizarion' do
    stranger = users(:baz)
    get api_event_submissions_path(@event, api_token: stranger.api_token)
    assert_response :forbidden
  end
end
