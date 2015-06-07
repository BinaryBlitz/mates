require 'test_helper'

class InvitesTest < ActionDispatch::IntegrationTest
  setup do
    @invitee = users(:baz)
    @event = events(:party)
  end

  test 'should create, accept, decline invites' do
    # Invite user to the event
    post '/api/invites', api_token: api_token, invite: { user_id: @invitee.id, event_id: @event.id }
    assert_response :created
    assert @invitee.invited_events.include?(@event)

    # Get the list of events
    get '/api/invites', api_token: @invitee.api_token
    assert_response :success
    assert_not_nil assigns(:invites)

    # Accept the invite
    patch "/api/invites/#{Invite.last.id}", api_token: @invitee.api_token
    assert_response :no_content
    assert @invitee.events.include?(@event)

    # Invite user to the event and decline the invite
    post '/api/invites', api_token: api_token, invite: { user_id: @invitee.id, event_id: @event.id }
    delete "/api/invites/#{Invite.last.id}", api_token: api_token
    refute @invitee.invited_events.include?(@event)
  end

  test 'should authorize users' do
    post '/api/invites', api_token: api_token, invite: { user_id: @invitee.id, event_id: @event.id }
    stranger = users(:john)

    patch "/api/invites/#{Invite.last.id}", api_token: stranger.api_token
    assert_response :unauthorized

    delete "/api/invites/#{Invite.last.id}", api_token: stranger.api_token
    assert_response :unauthorized
  end
end
