require 'test_helper'

class EventsTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:party)
  end

  test 'should get event types' do
    get api_categories_path(api_token: api_token)
    assert_response :success
  end

  test 'create' do
    attributes = %w(name city category_id user_limit min_age max_age gender starts_at visibility)

    assert_difference('Event.count') do
      post api_events_path(api_token: api_token), params: {
        event: @event.attributes.slice(*attributes)
      }
    end
    assert @event.creator.events.include?(Event.last)
  end

  test 'show' do
    get api_event_path(@event, api_token: api_token)
    assert_response :success
  end

  test 'show with sharing token' do
    get by_token_api_events_path(api_token: api_token, sharing_token: @event.sharing_token)
    assert_response :success
  end

  test 'update' do
    patch api_event_path(@event, api_token: @event.creator.api_token), params: {
      event: { name: 'New name' }
    }
    assert_response :ok
  end

  test 'destroy' do
    assert_difference('Event.count', -1) do
      delete api_event_path(@event, api_token: @event.creator.api_token)
    end
    assert_response :success
  end

  test 'set extra category' do
    patch api_event_path(@event, api_token: @event.creator.api_token), params: {
      event: { extra_category_id: categories(:movie).id }
    }
    assert_response :ok
  end

  test 'list friends available for invite' do
    get  available_friends_api_event_path(@event, api_token: @event.creator.api_token)
    assert_response :success
  end

  test 'should get feed' do
    get friends_api_feed_path(api_token: api_token)
    assert_response :success

    get recommended_api_feed_path(api_token: api_token)
    assert_response :success
  end

  test 'should authorize users' do
    stranger = users(:baz)
    patch api_event_path(@event, api_token: stranger.api_token)
    assert_response :forbidden

    delete api_event_path(@event, api_token: stranger.api_token)
    assert_response :forbidden
  end

  test 'search by category' do
    post api_searches_path(api_token: api_token), params: {
      search: { category_id: @event.category_id }
    }
    assert_response :created
  end
end
