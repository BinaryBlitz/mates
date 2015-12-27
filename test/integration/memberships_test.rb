require 'test_helper'

class MembershipsTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:party)
  end

  test 'create' do
    user = users(:baz)

    user.update!(birthday: 15.years.ago)
    post "/api/events/#{@event.id}/memberships", api_token: user.api_token
    assert_response :forbidden
    refute @event.users.include?(user)

    user.update!(birthday: 20.years.ago)
    post "/api/events/#{@event.id}/memberships", api_token: user.api_token
    assert_response :created
    assert @event.users.include?(user)
  end
end
