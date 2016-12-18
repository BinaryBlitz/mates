# == Schema Information
#
# Table name: friend_requests
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  accepted   :boolean
#

class FriendRequest < ActiveRecord::Base
  after_create :notify_friend
  after_update :notify_user

  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user, presence: true
  validates :friend, presence: true
  validate :not_self
  validate :not_friends
  validate :not_requested

  include Reviewable

  def accept
    update(accepted: true)
    user.friendships.create(friend: friend)
  end

  def decline
    update(accepted: false)
  end

  private

  def notify_friend
    return unless friend.notifications_friends?

    options = {
      action: 'FRIEND_REQUEST', count: friend.incoming_friend_requests.unreviewed.count
    }
    Notifier.new(friend, "#{user.full_name} хочет добавить вас в друзья", options)
  end

  def notify_user
    return unless user.notifications_friends?

    return unless accepted_changed? && accepted?
    options = { action: 'FRIEND_REQUEST_ACCEPTED' }
    Notifier.new(user, "#{friend.full_name} принял вашу заявку на добавление в друзья", options)
  end

  def not_self
    errors.add(:friend, "can't be equal to user") if user == friend
  end

  def not_friends
    return unless user
    errors.add(:friend, 'is already added') if user.friends.include?(friend)
  end

  def not_requested
    return unless user && friend

    if user.friend_requests.unreviewed.where(friend: friend).where.not(id: id).any?
      errors.add(:friend, 'has already received a request')
    end

    if friend.friend_requests.unreviewed.where(friend: user).where.not(id: id).any?
      errors.add(:friend, 'has already sent a request')
    end
  end
end
