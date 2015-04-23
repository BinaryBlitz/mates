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

class FriendRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user, presence: true
  validates :friend, presence: true, uniqueness: { scope: :user }
  validate :not_self
  validate :not_friends
  validate :not_pending

  def accept
    user.friends << friend
    friend.friends << user
    destroy
  end

  private

  def not_self
    errors.add(:friend, "can't be equal to user") if user == friend
  end

  def not_friends
    return unless user
    errors.add(:friend, "is already added") if user.friends.include?(friend)
  end

  def not_pending
    return unless friend
    errors.add(:friend, "already requested friendship") if friend.pending_friends.include?(user)
  end
end
