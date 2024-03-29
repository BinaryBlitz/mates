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

class Friendship < ActiveRecord::Base
  after_create :create_inverse_friendship
  after_create :invalidate_cache

  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user, presence: true
  validates :friend, presence:  true, uniqueness: { scope: :user }
  validate :not_self

  private

  def not_self
    errors.add(:friend, "can't be equal to user") if user == friend
  end

  def create_inverse_friendship
    Friendship.create(user: friend, friend: user)
  end

  def invalidate_cache
    events = Event.where(id: user.event_ids + friend.event_ids).upcoming
    events.find_each { |event| Rails.cache.delete(['feed', event]) }
  end
end
