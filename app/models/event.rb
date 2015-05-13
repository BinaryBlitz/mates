# == Schema Information
#
# Table name: events
#
#  id            :integer          not null, primary key
#  name          :string
#  starts_at     :datetime
#  ends_at       :datetime
#  city          :string
#  latitude      :float
#  longitude     :float
#  info          :text
#  visibility    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  address       :string
#  admin_id      :integer
#  photo         :string
#  event_type_id :integer
#  user_limit    :integer
#

class Event < ActiveRecord::Base
  after_create :attend

  belongs_to :admin, class_name: 'User'
  belongs_to :event_type

  has_many :proposals, dependent: :destroy
  has_many :proposed_users, through: :proposals, source: :user
  has_many :invites, dependent: :destroy
  has_many :invited_users, through: :invites, source: :user

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_many :comments, dependent: :destroy

  validates :admin, presence: true
  validates :event_type, presence: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :city, presence: true, length: { maximum: 30 }
  validates :user_limit, numericality: { greater_than: 0 }, allow_blank: true

  mount_base64_uploader :photo, PhotoUploader

  PREVIEW_USERS_COUNT = 2

  scope :past_events, -> { where('ends_at < ?', Time.now) }
  scope :upcoming_events, -> { where('starts_at >= ?', Time.now) }
  scope :not_attended_by, -> (user) { where.not(id: user.event_ids) }

  def preview_users
    users.where.not(id: admin.id).limit(PREVIEW_USERS_COUNT)
  end

  # List of recommended events
  def self.feed_for(current_user)
    feed_events_ids = attended_by_friends(current_user)
    feed_events_ids += find_by_past_event_attendees(current_user)
    where(id: feed_events_ids)
  end

  # Events attended by user's friends
  def self.attended_by_friends(current_user)
    joins(:users).merge(current_user.friends)
      .not_attended_by(current_user).upcoming_events
      .pluck('id')
  end

  # Events attended by users from past events
  def self.find_by_past_event_attendees(current_user)
    includes(:memberships)
      .where(memberships: { user_id: User.find_by_common_events(current_user) })
      .not_attended_by(current_user).upcoming_events.distinct
      .pluck('id')
  end

  private

  def attend
    admin.events << self
  end
end
