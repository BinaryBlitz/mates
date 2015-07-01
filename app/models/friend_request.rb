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
  after_create :notify_friend

  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user, presence: true
  validates :friend, presence: true, uniqueness: { scope: :user }
  validate :not_self
  validate :not_friends
  validate :not_pending

  def accept
    user.friends << friend
    notify_accepted
    destroy
  end

  private

  def notify_friend
    options = { action: 'FRIEND_REQUEST', friend_request: as_json }
    Notifier.new(friend, "#{user} хочет добавить вас в друзья", options).push
  end

  def notify_accepted
    options = { action: 'FRIEND_REQUEST_ACCEPTED', friend_request: as_json }
    Notifier.new(user, "#{friend} принял вашу заявку в друзья", options).push
  end

  def not_self
    errors.add(:friend, "can't be equal to user") if user == friend
  end

  def not_friends
    return unless user
    errors.add(:friend, 'is already added') if user.friends.include?(friend)
  end

  def not_pending
    return unless friend
    errors.add(:friend, 'already requested friendship') if friend.pending_friends.include?(user)
  end
end
