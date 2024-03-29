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
  after_update :invalidate_cache

  belongs_to :user
  belongs_to :event

  validates :user, presence: true
  validates :event, presence: true
  validate :not_member
  validate :not_submitted
  validate :not_invited

  delegate :creator, to: :event, allow_nil: true

  include Reviewable

  def accept
    update(accepted: true)
    event.users << user
    notify_user
  end

  def decline
    update(accepted: false)
  end

  private

  def notify_creator
    return unless creator.notifications_events?

    options = { action: 'NEW_SUBMISSION', count: creator.offer_count }
    Notifier.new(event.creator, "Новая заявка от #{user.full_name} на #{event}", options)
  end

  def notify_user
    return unless user.notifications_events?

    options = { action: 'SUBMISSION_APPROVED' }
    Notifier.new(user, "Ваша заявка на #{event.name} была одобрена", options)
  end

  def not_member
    return unless user
    errors.add(:event, 'is already a member') if user.events.include?(event)
  end

  def not_submitted
    return unless user

    if user.submissions.unreviewed.where(event: event).where.not(id: id).any?
      errors.add(:user, 'is already submitted')
    end
  end

  def not_invited
    return unless user
    errors.add(:user, 'is already invited') if user.invites.unreviewed.where(event: event).any?
  end

  def invalidate_cache
    Rails.cache.delete(self)
  end
end
