require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:party)
  end

  test "should get index" do
    get :index, api_token: api_token, format: :json
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should get show" do
    get :show, api_token: api_token, format: :json, id: @event
    assert_response :success
    assert_not_nil assigns(:event)
  end

  test "should create event" do
    assert_difference('Event.count') do
      post :create, api_token: api_token, format: :json, event: {
        admin_id: @event.admin_id,
        name: "new",
        target: "new",
        city: "new"
      }
    end
  end

  test 'should update event' do
    patch :update, id: @event, api_token: api_token, format: :json, event: {
      name: "edit", target: "edit" }
    assert_response :success
  end

  test 'should destroy event' do
    assert_difference('Event.count', -1) do
      delete :destroy, id: @event, api_token: api_token, format: :json
    end
    assert_response :success
  end
end