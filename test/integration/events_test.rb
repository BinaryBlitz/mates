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
    assert @event.admin.events.include?(Event.last)

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

  test 'should authorize users' do
    stranger = users(:baz)

    patch "/api/events/#{@event.id}", api_token: stranger.api_token
    assert_response :unauthorized

    delete "/api/events/#{@event.id}", api_token: stranger.api_token
    assert_response :unauthorized

    delete "/api/events/#{@event.id}/remove", api_token: stranger.api_token
    assert_response :unauthorized

    get "/api/events/#{@event.id}/proposals", api_token: stranger.api_token
    assert_response :unauthorized

    delete "/api/events/#{@event.id}/leave", api_token: api_token
    assert_response :unauthorized
  end

  test 'should remove users from event' do
    bad_user = users(:baz)
    @event.users << bad_user

    delete "/api/events/#{@event.id}/remove", api_token: api_token, user_id: bad_user.id
    assert_response :no_content
    refute @event.users.include?(bad_user)
  end
end
