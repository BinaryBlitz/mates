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
  after_destroy :notify_approval

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

  def notify_admin
    options = { action: 'NEW_SUBMISSION', submission: as_json }
    Notifier.new(event.admin.device_tokens, "Новая заявка от #{user} на #{event}", options).push
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

  def cannot_join
    errors.add(:user, 'can already join the event') if event.valid_user?(user)
  end
end
