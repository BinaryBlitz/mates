require 'test_helper'

class ProposalsTest < ActionDispatch::IntegrationTest
  setup do
    @proposed_user = users(:baz)
    @event = events(:party)
    @event.run_callbacks(:create)
  end

  test 'create' do
    post '/api/proposals.json',
         api_token: api_token, proposal: { user_id: @proposed_user.id, event_id: @event.id }
    assert_response :created
    assert @proposed_user.proposed_events.include?(@event)
  end

  test 'list' do
    get "/api/events/#{@event.id}/proposals.json", api_token: api_token
    assert_response :success
  end

  test 'accept' do
    proposal = @event.proposals.create(creator: @event.admin, user: @proposed_user)
    patch "/api/proposals/#{proposal.id}", api_token: @event.admin.api_token
    assert_response :created
    refute @proposed_user.events.include?(@event)
  end

  test 'decline' do
    proposal = @event.proposals.create(creator: @event.admin, user: @proposed_user)
    delete "/api/proposals/#{proposal.id}", api_token: @event.admin.api_token
    assert_response :no_content
    refute @proposed_user.proposed_events.include?(@event)
  end

  test 'should authorize users' do
    stranger = users(:john)
    proposal = @event.proposals.create(creator: @event.admin, user: @proposed_user)

    patch "/api/proposals/#{Proposal.last.id}", api_token: stranger.api_token
    assert_response :forbidden

    delete "/api/proposals/#{Proposal.last.id}", api_token: stranger.api_token
    assert_response :forbidden
  end
end
