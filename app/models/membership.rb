# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Membership < ActiveRecord::Base
  after_create :notify_followers
  after_destroy :notify_removal

  belongs_to :user
  belongs_to :event

  validates :user, presence: true
  validates :event, presence: true, uniqueness: { scope: :user }

  private

  def notify_followers
    return if user == event.creator

    user.followers.each do |follower|
      Notifier.new(
        follower, "#{user} присоединился к #{event}",
        action: 'JOINED_EVENT', membership: as_json
      ).push
    end
  end

  def notify_removal
    options = { action: 'USER_REMOVED', membership: as_json }
    Notifier.new(user, "Вы исключены из #{event}", options).push
  end
end
