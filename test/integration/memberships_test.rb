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
    post api_event_memberships_path(@event, api_token: user.api_token)
    assert_response :forbidden
    refute @event.users.include?(user)

    user.update!(birthday: 20.years.ago)
    post api_event_memberships_path(@event, api_token: user.api_token)
    assert_response :created
    assert @event.users.include?(user)
  end

  test 'destroy' do
    member = users(:baz)
    membership = @event.memberships.create(user: member)
    delete api_membership_path(membership, api_token: member.api_token)
    assert_response :no_content
    refute @event.users.include?(member)
  end

  test 'authorization' do
    stranger = users(:baz)
    delete api_membership_path(@membership, api_token: stranger.api_token)
    assert_response :forbidden
  end
end
