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
  after_create :notify_respondent

  belongs_to :user
  belongs_to :event
  belongs_to :respondent, class_name: 'User'

  validates :user, presence: true
  validates :event, presence: true
  validate :respondent_membership

  private

  def notify_creator
    return if user == event.creator

    options = { action: 'NEW_COMMENT', comment: as_json }
    Notifier.new(event.creator, "#{user} оставил комментарий к #{event}", options).push
  end

  def notify_respondent
    return unless respondent

    options = { action: 'NEW_MENTION', comment: as_json }
    Notifier.new(respondent, "#{user} упомянул вас в комментарии к #{event}", options).push
  end

  def respondent_membership
    return unless respondent

    unless event.users.include?(respondent)
      errors.add(:respondent, "doesn't participate in the event")
    end
  end
end
