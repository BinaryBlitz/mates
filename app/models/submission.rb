# == Schema Information
#
# Table name: submissions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Submission < ActiveRecord::Base
  after_create :notify_admin

  belongs_to :user
  belongs_to :event

  validates :user, presence: true
  validates :event, presence: true, uniqueness: { scope: :user }
  validate :not_visited
  validate :not_invited
  validate :can_already_join
  validate :cannot_join

  def accept
    event.users << user
    notify_approval
    destroy
  end

  private

  def notify_admin
    options = { action: 'NEW_SUBMISSION', submission: as_json }
    Notifier.new(event.admin, "Новая заявка от #{user} на #{event}", options).push
  end

  def notify_approval
    options = { action: 'SUBMISSION_APPROVED', submission: as_json }
    Notifier.new(user, "Ваша заявка на #{event.name} была одобрена", options).push
  end

  def not_visited
    errors.add(:event, 'is already visited') if user.events.include?(event)
  end

  def not_invited
    errors.add(:user, 'is already invited') if user.invited_events.include?(event)
  end

  def can_already_join
    errors.add(:user, 'can already join the event') if event.invited_users.include?(user)
  end

  def cannot_join
    errors.add(:user, 'cannot join the event') unless event.valid_user?(user)
  end
end
