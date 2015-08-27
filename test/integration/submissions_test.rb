require 'test_helper'

class SubmissionsTest < ActionDispatch::IntegrationTest
  setup do
    @guest = users(:baz)
    @event = events(:party)
  end

  test 'cannot submit with invalid age or gender' do
    @guest.update!(birthday: 15.years.ago)
    post '/api/submissions', api_token: @guest.api_token, event_id: @event.id
    assert_response 422
  end

  test 'create with valid age' do
    post '/api/submissions', api_token: @guest.api_token, event_id: @event.id
    assert_response :created
  end

  test 'list' do
    @guest.submissions.create!(event: @event)
    get '/api/submissions', api_token: @guest.api_token
    assert_response :success
    assert_equal @guest.submissions.count, json_response.size
  end

  test 'accept' do
    submission = @guest.submissions.create!(event: @event)
    patch "/api/submissions/#{submission.id}", api_token: @event.admin.api_token
    assert_response :no_content
  end

  test 'decline or cancel' do
    submission = @guest.submissions.create!(event: @event)
    delete "/api/submissions/#{submission.id}", api_token: @event.admin.api_token
    assert_response :no_content
  end
end
