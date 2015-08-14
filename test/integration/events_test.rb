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

  test 'should get event types' do
    get '/api/event_types', api_token: api_token
    assert_response :success
  end

  test 'should create, read, update and destroy event' do
    assert_difference('Event.count') do
      post '/api/events', api_token: api_token, event: {
        name: 'new', city: 'new',
        event_type_id: @event.event_type.id, user_limit: 2,
        min_age: @event.min_age, max_age: @event.max_age, gender: @event.gender
      }
    end
    assert @event.admin.events.include?(Event.last)

    get "/api/events/#{Event.last.id}", api_token: api_token
    assert_response :success
    assert_not_nil assigns(:event)

    patch "/api/events/#{Event.last.id}", api_token: api_token, event: { name: 'edit' }
    assert_response :success

    assert_difference('Event.count', -1) do
      delete "/api/events/#{Event.last.id}", api_token: api_token
    end
    assert_response :success
  end

  test 'should get feed' do
    get '/api/events/feed', api_token: api_token
    assert_response :success
  end

  test 'should authorize users' do
    stranger = users(:baz)

    patch "/api/events/#{@event.id}", api_token: stranger.api_token
    assert_response :forbidden

    delete "/api/events/#{@event.id}", api_token: stranger.api_token
    assert_response :forbidden

    delete "/api/events/#{@event.id}/remove", api_token: stranger.api_token
    assert_response :forbidden

    get "/api/events/#{@event.id}/proposals", api_token: stranger.api_token
    assert_response :forbidden

    get "/api/events/#{@event.id}/submissions", api_token: stranger.api_token
    assert_response :forbidden

    delete "/api/events/#{@event.id}/leave", api_token: api_token
    assert_response :forbidden
  end

  test 'should remove users from event' do
    bad_user = users(:baz)
    @event.users << bad_user

    delete "/api/events/#{@event.id}/remove", api_token: api_token, user_id: bad_user.id
    assert_response :no_content
    refute @event.users.include?(bad_user)
  end

  test 'users can join events' do
    user = users(:baz)

    user.update!(birthday: 15.years.ago)
    post "/api/events/#{@event.id}/join", api_token: user.api_token
    assert_response :forbidden
    refute @event.users.include?(user)

    user.update!(birthday: 20.years.ago)
    post "/api/events/#{@event.id}/join", api_token: user.api_token
    assert_response :created
    assert @event.users.include?(user)
  end

  test 'event proposals' do
    get "/api/events/#{@event.id}/proposals", api_token: api_token
    assert_response :success
  end

  test 'event submissions' do
    get "/api/events/#{@event.id}/submissions", api_token: api_token
    assert_response :success
  end

  test 'search by name' do
    post '/api/searches', api_token: api_token, search: { name: @event.name }
    assert_response :created
    # byebug
    assert_equal @event.name, json_response.first[:name]
  end

  test 'search by category' do
    post '/api/searches', api_token: api_token, search: { event_type_id: @event.event_type_id }
    assert_response :created
    assert_equal @event.event_type_id, json_response.first[:event_type_id]
  end
end
