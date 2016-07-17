require 'test_helper'

class InvitesTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:party)
    @invitee = users(:invitee)
    @invite = invites(:invite)
  end

  test 'create' do
    post api_event_invites_path(@event, api_token: @event.creator.api_token), params: {
      invite: { user_id: users(:baz).id, event_id: @event.id }
    }
    assert_response :created
  end

  test 'list' do
    get api_event_invites_path(@event, api_token: @invitee.api_token)
    assert_response :success
  end

  test 'accept' do
    patch api_invite_path(@invite, api_token: @invitee.api_token)
    assert_response :ok
    assert @invitee.events.include?(@event)
  end

  test 'decline' do
    patch decline_api_invite_path(@invite, api_token: @invite.user.api_token)
    assert_response :ok
  end

  test 'cancel' do
    delete api_invite_path(@invite, api_token: @event.creator.api_token)
    assert_response :no_content
  end

  test 'should authorize users' do
    post api_event_invites_path(@event, api_token: api_token), params: {
      invite: { user_id: @invitee.id, event_id: @event.id }
    }
    stranger = users(:john)

    patch api_invite_path(Invite.last, api_token: stranger.api_token)
    assert_response :forbidden

    delete api_invite_path(Invite.last, api_token: stranger.api_token)
    assert_response :forbidden
  end
end
