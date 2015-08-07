require 'test_helper'

class InvitesTest < ActionDispatch::IntegrationTest
  setup do
    @invite = invites(:invite)
    @invitee = users(:invitee)
    @event = events(:party)
  end

  test 'invite' do
    post '/api/invites', api_token: api_token, invite: { user_id: users(:baz).id, event_id: @event.id }
    assert_response :created
    assert @invitee.invited_events.include?(@event)
  end

  test 'list' do
    get '/api/invites', api_token: @invitee.api_token
    assert_response :success
    assert_not_nil assigns(:invites)
  end

  test 'accept' do
    patch "/api/invites/#{Invite.last.id}", api_token: @invitee.api_token
    assert_response :no_content
    assert @invitee.events.include?(@event)
  end

  test 'decline' do
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
