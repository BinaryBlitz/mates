class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :user, presence: true
  validates :event, presence: true, uniqueness: { scope: :user }
  validate :not_visited
  validate :not_invited
  validate :cannot_join

  def accept
    event.users << user
    destroy
  end

  private

  def not_visited
    errors.add(:event, 'is already visited') if user.events.include?(event)
  end

  def not_invited
    errors.add(:user, 'is already invited') if user.invited_events.include?(event)
  end

  def cannot_join
    errors.add(:user, 'can already join the event') if event.valid_user?(user)
  end
end
