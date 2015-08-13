# == Schema Information
#
# Table name: events
#
#  id            :integer          not null, primary key
#  name          :string
#  starts_at     :datetime
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
#  user_limit    :integer          default(1)
#  min_age       :integer
#  max_age       :integer
#  gender        :string(1)
#

class Event < ActiveRecord::Base
  after_create :attend
  after_create :notify_followers
  after_update :notify_members

  belongs_to :admin, class_name: 'User'
  belongs_to :event_type

  has_many :proposals, dependent: :destroy
  has_many :proposed_users, through: :proposals, source: :user
  has_many :invites, dependent: :destroy
  has_many :invited_users, through: :invites, source: :user

  has_many :submissions, dependent: :destroy
  has_many :submitted_users, through: :submissions, source: :user

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_many :comments, dependent: :destroy

  validates :admin, presence: true
  validates :event_type, presence: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :city, presence: true, length: { maximum: 30 }
  validates :user_limit, numericality: { greater_than: 1 }, allow_blank: true

  #  Filter validations
  validates :gender, length: { is: 1 }, inclusion: { in: %w(f m) }, allow_nil: true

  validates :min_age, numericality: { greater_than: 0 }, allow_nil: true
  validates :max_age, numericality: { less_than_or_equal_to: 100 }, allow_nil: true

  validates :min_age, numericality: { less_than_or_equal_to: :max_age },
                      if: 'max_age.present?', allow_nil: true
  validates :max_age, numericality: { greater_than_or_equal_to: :min_age },
                      if: 'min_age.present?', allow_nil: true

  mount_base64_uploader :photo, PhotoUploader

  PREVIEW_USERS_COUNT = 2

  scope :past_events, -> { where('ends_at < ?', Time.zone.now) }
  scope :upcoming, -> { where('starts_at >= ?', Time.zone.now) }

  def preview_users
    users.where.not(id: admin.id).limit(PREVIEW_USERS_COUNT)
  end

  def propose(proposed_user, creator)
    proposals.create(user: proposed_user, creator: creator)
  end

  def age_interval
    from = min_age || 0
    to = max_age || 100
    from..to
  end

  def valid_gender?(user_gender)
    return true if gender.nil?

    gender == user_gender
  end

  def valid_age?(user_age)
    return true if min_age.nil? && max_age.nil?

    age_interval.include?(user_age)
  end

  def valid_user?(new_user)
    valid_gender?(new_user.gender) && valid_age?(new_user.age)
  end

  def to_s
    "#{name}"
  end

  private

  def attend
    admin.events << self
  end

  def notify_followers
    admin.followers.each do |follower|
      options = { action: 'NEW_EVENT', event: as_json }
      Notifier.new(follower, "Новое событие от #{admin}: #{name}", options).push
    end
  end

  def notify_members
    users.each do |user|
      options = { action: 'EVENT_UPDATED', event: as_json }
      Notifier.new(user, "Событие обновлено: #{self}", options).push
    end
  end
end
