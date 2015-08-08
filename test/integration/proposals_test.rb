require 'test_helper'

class ProposalsTest < ActionDispatch::IntegrationTest
  setup do
    @proposed_user = users(:baz)
    @event = events(:party)
  end

  test 'should create, accept, decline proposals' do
    # Allow user to propose
    @event.users << users(:foo)

    # Propose user to the event
    post '/api/proposals',
         api_token: api_token, proposal: { user_id: @proposed_user.id, event_id: @event.id }
    assert_response :created
    assert @proposed_user.proposed_events.include?(@event)

    # List proposals
    get "/api/events/#{@event.id}/proposals", api_token: api_token
    assert_response :success
    assert_not_nil assigns(:proposals)

    # Accept the proposal
    patch "/api/proposals/#{Proposal.last.id}", api_token: @event.admin.api_token
    assert_response :no_content
    refute @proposed_user.events.include?(@event)

    # Propose user to the event and decline the proposal
    post '/api/proposals',
         api_token: api_token, proposal: { user_id: @proposed_user.id, event_id: @event.id }
    delete "/api/proposals/#{Proposal.last.id}", api_token: @event.admin.api_token
    assert_response :no_content
    refute @proposed_user.proposed_events.include?(@event)
  end

  test 'should authorize users' do
    stranger = users(:john)
    @event.users << users(:foo)
    post '/api/proposals',
         api_token: api_token, proposal: { user_id: @proposed_user.id, event_id: @event.id }

    patch "/api/proposals/#{Proposal.last.id}", api_token: stranger.api_token
    assert_response :forbidden

    delete "/api/proposals/#{Proposal.last.id}", api_token: stranger.api_token
    assert_response :forbidden
  end
end
