require 'test_helper'

class EventsTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:party)
  end

  test 'should get event types' do
    get '/api/categories.json', api_token: api_token
    assert_response :success
  end

  test 'create' do
    assert_difference('Event.count') do
      post '/api/events.json', api_token: api_token, event: {
        name: @event.name, city: @event.city,
        category_id: @event.category.id, user_limit: @event.user_limit,
        min_age: @event.min_age, max_age: @event.max_age, gender: @event.gender
      }
    end
    assert @event.creator.events.include?(Event.last)
  end

  test 'show' do
    get "/api/events/#{@event.id}.json", api_token: api_token
    assert_response :success
    assert_not_nil assigns(:event)
  end

  test 'show with sharing token' do
    get "/api/events/by_token.json", api_token: api_token, sharing_token: @event.sharing_token
    assert_response :success
  end

  test 'update' do
    patch "/api/events/#{@event.id}", api_token: @event.creator.api_token, event: {
      name: 'New name'
    }
    assert_response :ok
  end

  test 'destroy' do
    assert_difference('Event.count', -1) do
      delete "/api/events/#{@event.id}", api_token: @event.creator.api_token
    end
    assert_response :success
  end

  test 'set extra category' do
    patch "/api/events/#{@event.id}", api_token: @event.creator.api_token, event: {
      extra_category_id: categories(:movie).id
    }
    assert_response :ok
  end

  test 'list friends available for invite' do
    get  "/api/events/#{@event.id}/available_friends.json", api_token: @event.creator.api_token
    assert_response :success
  end

  test 'should get feed' do
    get '/api/feed/friends.json', api_token: api_token
    assert_response :success

    get '/api/feed/recommended.json', api_token: api_token
    assert_response :success
  end

  test 'should authorize users' do
    stranger = users(:baz)
    patch "/api/events/#{@event.id}", api_token: stranger.api_token
    assert_response :forbidden

    delete "/api/events/#{@event.id}", api_token: stranger.api_token
    assert_response :forbidden
  end

  test 'search by category' do
    post '/api/searches.json', api_token: api_token, search: { category_id: @event.category_id }
    assert_response :created
  end
end
