# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  creator_id :integer
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ActiveRecord::Base
  after_create :push

  belongs_to :user
  belongs_to :creator, class_name: 'User'

  validates :user, presence: true
  validates :creator, presence: true
  validates :content, presence: true

  scope :by_user, -> (u) { where('user_id = ? OR creator_id = ?', u, u) }

  private

  def push
    Notifier.new(user, content, action: 'MESSAGE', message: as_json).push unless user.online?
  end
end
