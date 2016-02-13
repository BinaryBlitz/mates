# == Schema Information
#
# Table name: invites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  accepted   :boolean
#

class Invite < ActiveRecord::Base
  after_create :notify_user
  after_update :notify_creator
  after_update :invalidate_cache

  belongs_to :user
  belongs_to :event

  validates :user, presence: true
  validate :not_member
  validate :not_invited
  validate :event_date_valid

  delegate :creator, to: :event, allow_nil: true

  include Reviewable

  # User accepts the invite and joins the event
  def accept
    update!(accepted: true)
    user.events << event
  end

  def decline
    update!(accepted: false)
  end

  private

  def notify_user
    options = { action: 'INVITE', invite: as_json }
    Notifier.new(user, "Вас пригласили на событие: #{event}", options)
  end

  def notify_creator
    return unless accepted_changed? && accepted?
    options = { action: 'INVITE_ACCEPTED', invite: as_json, count: creator.offer_count }
    Notifier.new(creator, 'Ваше приглашение было принято', options)
  end

  def not_member
    return unless event.users.include?(user)
    errors.add(:user, 'is already a member')
  end

  def not_invited
    return unless event.invites.unreviewed.where(user: user).where.not(id: id).any?
    errors.add(:user, 'is already invited to the event')
  end

  def event_date_valid
    return unless event.starts_at && event.starts_at <= Time.zone.now
    errors.add(:event, 'has already started')
  end

  def invalidate_cache
    Rails.cache.delete(self)
  end
end
