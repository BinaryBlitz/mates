# == Schema Information
#
# Table name: submissions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  accepted   :boolean
#

class Submission < ActiveRecord::Base
  after_create :notify_creator

  belongs_to :user
  belongs_to :event

  validates :user, presence: true
  validates :event, presence: true, uniqueness: { scope: :user }
  validate :not_visited
  validate :not_invited
  validate :can_already_join
  validate :cannot_join

  include Reviewable

  def accept
    event.users << user
    notify_user
    update(accepted: true)
  end

  def decline
    update(accepted: false)
  end

  private

  def notify_creator
    options = { action: 'NEW_SUBMISSION', submission: as_json }
    Notifier.new(event.creator, "Новая заявка от #{user} на #{event}", options)
  end

  def notify_user
    options = { action: 'SUBMISSION_APPROVED', submission: as_json }
    Notifier.new(user, "Ваша заявка на #{event.name} была одобрена", options)
  end

  def not_visited
    return unless user
    errors.add(:event, 'is already visited') if user.events.include?(event)
  end

  def not_invited
    return unless user
    errors.add(:user, 'is already invited') if user.invites.where(event: event).any?
  end

  def can_already_join
    return unless event
    errors.add(:user, 'can already join the event') if event.invited_users.include?(user)
  end

  def cannot_join
    return unless event
    errors.add(:user, 'cannot join the event because of limitations') unless event.valid_user?(user)
  end
end
