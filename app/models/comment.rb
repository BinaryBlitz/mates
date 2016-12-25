# == Schema Information
#
# Table name: comments
#
#  id            :integer          not null, primary key
#  content       :string
#  user_id       :integer
#  event_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  respondent_id :integer
#

class Comment < ActiveRecord::Base
  after_create :notify_creator

  belongs_to :user
  belongs_to :event
  belongs_to :respondent, class_name: 'User'

  validates :user, presence: true
  validates :event, presence: true
  validate :respondent_membership

  private

  def notify_creator
    return if user == event.creator
    return unless event.creator.notifications_events?

    options = { action: 'NEW_COMMENT' }
    Notifier.new(event.creator, "#{user.full_name} оставил комментарий к #{event}", options)
  end

  def respondent_membership
    return unless respondent

    unless event.users.include?(respondent)
      errors.add(:respondent, "doesn't participate in the event")
    end
  end
end
