# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FriendshipTest < ActiveSupport::TestCase
  def setup
    @friendship = Friendship.new(user: users(:foo), friend: users(:baz))
  end

  test 'invalid without user' do
    @friendship.user = nil
    assert @friendship.invalid?
  end

  test 'invalid without friend' do
    @friendship.friend = nil
    assert @friendship.invalid?
  end

  test 'invalid if friend is user' do
    @friendship.friend = @friendship.user
    assert @friendship.invalid?
  end

  test 'should create inverse friendship' do
    assert_not @friendship.user.friends.include?(@friendship.friend)
    @friendship.save

    assert @friendship.user.friends.include?(@friendship.friend)
    assert @friendship.friend.friends.include?(@friendship.user)
  end
end
