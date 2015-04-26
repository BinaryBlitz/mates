require 'test_helper'

class EventsTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:party)
  end

  test 'should get index' do
    get '/api/events', api_token: api_token
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test 'should create, read, update and destroy event' do
    assert_difference('Event.count') do
      post '/api/events', api_token: api_token, event: {
        admin_id: @event.admin_id,
        name: 'new',
        target: 'new',
        city: 'new'
      }
    end

    get "/api/events/#{Event.last.id}", api_token: api_token
    assert_response :success
    assert_not_nil assigns(:event)

    patch "/api/events/#{Event.last.id}", api_token: api_token, event: {
      name: 'edit', target: 'edit' }
    assert_response :success

    assert_difference('Event.count', -1) do
      delete "/api/events/#{Event.last.id}", api_token: api_token
    end
    assert_response :success
  end
end
