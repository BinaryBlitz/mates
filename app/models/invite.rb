# == Schema Information
#
# Table name: invites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Invite < ActiveRecord::Base
  after_create :notify_invitee

  belongs_to :user
  belongs_to :event

  validates :user, presence: true
  validates :event, presence: true, uniqueness: { scope: :user }

  # User accepts the invite and joins the event
  def accept
    user.events << event
    notify_admin
    destroy
  end

  private

  def notify_invitee
    options = { action: 'INVITE', invite: as_json }
    Notifier.new(user, "Вас пригласили на событие: #{event}", options).push
  end

  def notify_admin
    options = { action: 'INVITE_ACCEPTED', invite: as_json }
    Notifier.new(event.admin, "#{user} согласился на участие в #{event}", options).push
  end
end
