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

  scope :upcoming_events, -> { where('starts_at >= ?', Time.now)}
  scope :not_participated_by, ->(user) { where.not(id: user.event_ids)}

  def preview_users
    users.where.not(id: admin.id).limit(PREVIEW_USERS_COUNT)
  end


  def self.created_or_participated_by_friends(current_user)
    friends = current_user.friend_ids
    joins(:users).where(users: {id: current_user.friend_ids})
    .not_participated_by(current_user)
  end


  private

  def attend
    admin.events << self
  end
end
