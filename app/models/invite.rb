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

  belongs_to :user
  belongs_to :event

  validates :user, presence: true
  validate :not_a_member
  validate :not_already_invited

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

  def not_a_member
    return unless event.users.include?(user)
    errors.add(:user, 'is already a member')
  end

  def not_already_invited
    return unless event.invites.where(user: user, accepted: nil).where.not(id: id).any?
    errors.add(:user, 'is already invited to the event')
  end
end
