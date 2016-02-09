require 'test_helper'

class ActivityTest < ActionDispatch::IntegrationTest
  test 'show activity page' do
    get '/api/activity.json', api_token: api_token
    assert_response :success
  end
end
