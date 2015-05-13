# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  name       :string
#  target     :string
#  starts_at  :datetime
#  ends_at    :datetime
#  city       :string
#  latitude   :float
#  longitude  :float
#  info       :text
#  visibility :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  address    :string
#  admin_id   :integer
#  photo      :string
#

class Event < ActiveRecord::Base
  after_create :attend

  belongs_to :admin, class_name: 'User'

  has_many :proposals, dependent: :destroy
  has_many :proposed_users, through: :proposals, source: :user
  has_many :invites, dependent: :destroy
  has_many :invited_users, through: :invites, source: :user

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_many :comments, dependent: :destroy

  validates :admin, presence: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :target, presence: true, length: { maximum: 20 }
  validates :city, presence: true, length: { maximum: 30 }

  mount_base64_uploader :photo, PhotoUploader

  PREVIEW_USERS_COUNT = 2

  scope :not_participated_by, ->(user) { where.not(id: user.event_ids)}
  scope :past_events, -> { where('ends_at < ?', Time.now)}
  scope :upcoming_events, -> { where('starts_at >= ?', Time.now)}

  def preview_users
    users.where.not(id: admin.id).limit(PREVIEW_USERS_COUNT)
  end

  def self.feed_for(current_user)
    feed_events_ids = self.attended_by_friends(current_user)
    feed_events_ids += self.find_by_past_event_attendees(current_user)
    where(id: feed_events_ids)
  end

  def self.attended_by_friends(current_user)
    joins(:users).merge(current_user.friends)
    .not_participated_by(current_user)
    .upcoming_events
    .pluck("id")
  end

  def self.find_by_past_event_attendees(current_user)
    includes(:memberships)
    .where(memberships: { user_id: User.from_events_participated_by(current_user)})
    .not_participated_by(current_user)
    .upcoming_events
    .distinct
    .pluck("id")
  end

  private

  def attend
    admin.events << self
  end
end
