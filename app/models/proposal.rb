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
  after_create :notify_creator

  belongs_to :user
  belongs_to :event
  belongs_to :creator, class_name: 'User'

  validates :user, presence: true
  validates :event, presence: true
  validates :creator, presence: true

  # Admin accepts the proposal and invites the user
  def accept
    destroy
    event.invites.find_or_create_by(user: user)
  end

  private

  def notify_creator
    options = { action: 'NEW_PROPOSAL', proposal: as_json }
    Notifier.new(event.creator, "#{creator} предложил #{user} для участия в #{event}", options)
  end
end
