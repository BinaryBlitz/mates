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
  validates :event, presence: true, uniqueness: { scope: :user }

  scope :reviewed, -> { where.not(accepted: nil) }

  # User accepts the invite and joins the event
  def accept
    user.events << event
    update(accepted: true)
  end

  def decline
    update(accepted: false)
  end

  private

  def notify_user
    options = { action: 'INVITE', invite: as_json }
    Notifier.new(user, "Вас пригласили на событие: #{event}", options)
  end
end
