require 'test_helper'

class ProposalsTest < ActionDispatch::IntegrationTest
  setup do
    @proposed_user = users(:baz)
    @event = events(:party)
    @event.run_callbacks(:create)
  end

  test 'create' do
    post "/api/events/#{@event.id}/proposals.json",
         api_token: api_token, proposal: { user_id: @proposed_user.id }
    assert_response :created
    assert @proposed_user.proposed_events.include?(@event)
  end

  test 'list' do
    get "/api/events/#{@event.id}/proposals.json", api_token: api_token
    assert_response :success
  end

  test 'accept' do
    proposal = @event.proposals.create(creator: @event.creator, user: @proposed_user)
    patch "/api/proposals/#{proposal.id}", api_token: @event.creator.api_token
    assert_response :ok
    refute @proposed_user.events.include?(@event)
  end

  test 'decline' do
    proposal = @event.proposals.create(creator: @event.creator, user: @proposed_user)
    delete "/api/proposals/#{proposal.id}", api_token: @event.creator.api_token
    assert_response :no_content
    refute @proposed_user.proposed_events.include?(@event)
  end

  test 'authorization' do
    stranger = users(:john)
    proposal = @event.proposals.create(creator: @event.creator, user: @proposed_user)

    patch "/api/proposals/#{proposal.id}.json", api_token: stranger.api_token
    assert_response :forbidden

    delete "/api/proposals/#{proposal.id}.json", api_token: stranger.api_token
    assert_response :forbidden

    get "/api/events/#{@event.id}/proposals.json", api_token: stranger.api_token
    assert_response :forbidden
  end
end
