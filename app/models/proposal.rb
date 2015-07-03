# == Schema Information
#
# Table name: proposals
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  event_id   :integer
#  creator_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Proposal < ActiveRecord::Base
  after_create :notify_admin

  belongs_to :user
  belongs_to :event
  belongs_to :creator, class_name: 'User'

  validates :user, presence: true
  validates :event, presence: true
  validates :creator, presence: true

  # Admin accepts the proposal and invites the user
  def accept
    event.invited_users << user
    # Push the notification
    destroy
  end

  private

  def notify_admin
    options = { action: 'NEW_PROPOSAL', proposal: as_json }
    Notifier.new(event.admin, "#{creator} предложил #{user} для участия в #{event}", options).push
  end
end
