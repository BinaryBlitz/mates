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
  after_destroy :notify_removal

  belongs_to :user
  belongs_to :event

  validates :user, presence: true
  validates :event, presence: true, uniqueness: { scope: :user }

  scope :order_by_starting_date, -> { joins(:event).order('events.starts_at DESC') }

  private

  def notify_removal
    options = { action: 'USER_REMOVED', membership: as_json }
    Notifier.new(user, "Вы исключены из #{event}", options)
  end
end
