require 'test_helper'

class SubmissionsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:baz)
    @event = events(:party)
  end

  test 'should create, update and destroy submissions' do
    @user.update(birthday: Date.today, password: 'foobar')

    post '/api/submissions', api_token: @user.api_token, submission: { event_id: @event.id }
    assert_response :created

    get '/api/submissions', api_token: @user.api_token
    assert_response :success

    patch "/api/submissions/#{Submission.last.id}", api_token: api_token
    assert_response :no_content
    assert @event.users.include?(@user)
  end
end
