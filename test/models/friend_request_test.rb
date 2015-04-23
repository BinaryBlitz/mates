# == Schema Information
#
# Table name: friend_requests
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FriendRequestTest < ActiveSupport::TestCase
  def setup
    @friend_request = FriendRequest.create(user: users(:foo), friend: users(:baz))
  end

  test 'invalid without user' do
    @friend_request.user = nil
    assert @friend_request.invalid?
  end

  test 'invalid without friend' do
    @friend_request.friend = nil
    assert @friend_request.invalid?
  end

  test 'invalid if friend is user' do
    @friend_request.friend = @friend_request.user
    assert @friend_request.invalid?
  end

  test 'invalid if request already exists' do
    copy = @friend_request.dup
    assert copy.invalid?
  end

  test 'invalid if user requested friendship' do
    inverse_request = FriendRequest.create(user: users(:baz), friend: users(:foo))
    assert inverse_request.invalid?
  end
end
