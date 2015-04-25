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
  belongs_to :user
  belongs_to :event
  belongs_to :creator, class_name: 'User'

  validates :user, presence: true
  validates :event, presence: true
  validates :creator, presence: true

  def accept
    # Destroy proposal and create invite
  end
end
