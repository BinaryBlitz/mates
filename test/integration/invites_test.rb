require 'test_helper'

class InvitesTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:party)
    @invitee = users(:invitee)
    @invite = invites(:invite)
  end

  test 'create' do
    post "/api/events/#{@event.id}/invites.json", api_token: @event.creator.api_token, invite: {
      user_id: users(:baz).id, event_id: @event.id
    }
    assert_response :created
    assert @invitee.invited_events.include?(@event)
  end

  test 'list' do
    get "/api/events/#{@event.id}/invites.json", api_token: @invitee.api_token
    assert_response :success
    assert_not_nil assigns(:invites)
  end

  test 'accept' do
    patch "/api/invites/#{@invite.id}.json", api_token: @invitee.api_token
    assert_response :ok
    assert @invitee.events.include?(@event)
  end

  test 'decline' do
    delete "/api/invites/#{@invite.id}.json", api_token: api_token
    refute @invitee.invited_events.include?(@event)
  end

  test 'should authorize users' do
    post "/api/events/#{@event.id}/invites.json", api_token: api_token, invite: {
      user_id: @invitee.id, event_id: @event.id
    }
    stranger = users(:john)

    patch "/api/invites/#{Invite.last.id}.json", api_token: stranger.api_token
    assert_response :forbidden

    delete "/api/invites/#{Invite.last.id}.json", api_token: stranger.api_token
    assert_response :forbidden
  end
end
