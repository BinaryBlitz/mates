class FriendshipTest < ActiveSupport::TestCase
  def setup
    @friendship = friendships(:friendship)
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
end
