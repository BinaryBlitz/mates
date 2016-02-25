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
  after_create :invalidate_cache

  belongs_to :user
  belongs_to :event, counter_cache: true

  validates :user, presence: true
  validates :event, presence: true, uniqueness: { scope: :user }

  scope :order_by_starting_date, -> { joins(:event).order('events.starts_at DESC') }
  scope :available_for, -> (user) { joins(:event).merge(Event.available_for(user)) }

  private

  def notify_removal
    options = { action: 'USER_REMOVED', membership: as_json }
    Notifier.new(user, "Вы исключены из #{event}", options)
  end

  def invalidate_cache
    Rails.cache.delete(['feed', event])
  end
end
