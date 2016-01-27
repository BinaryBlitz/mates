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
  validate :user_joined?
  validate :user_invited?

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

  def user_joined?
    return unless user
    errors.add(:event, 'is already visited') if user.events.include?(event)
  end

  def user_invited?
    return unless user
    errors.add(:user, 'is already invited') if user.invites.where(event: event).unreviewed.any?
  end
end
