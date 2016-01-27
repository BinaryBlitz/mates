require 'test_helper'

class MembershipsTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:party)
    @user = users(:foo)
    @membership = @event.memberships.create!(user: @user)
  end

  test 'create' do
    user = users(:baz)

    user.update!(birthday: 15.years.ago)
    post "/api/events/#{@event.id}/memberships.json", api_token: user.api_token
    assert_response :forbidden
    refute @event.users.include?(user)

    user.update!(birthday: 20.years.ago)
    post "/api/events/#{@event.id}/memberships.json", api_token: user.api_token
    assert_response :created
    assert @event.users.include?(user)
  end

  test 'destroy' do
    member = users(:baz)
    membership = @event.memberships.create(user: member)
    delete "/api/memberships/#{membership.id}.json", api_token: member.api_token
    assert_response :no_content
    refute @event.users.include?(member)
  end

  test 'authorization' do
    stranger = users(:baz)
    delete "/api/memberships/#{@membership.id}.json", api_token: stranger.api_token
    assert_response :forbidden
  end
end
