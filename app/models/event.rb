# == Schema Information
#
# Table name: events
#
#  id                :integer          not null, primary key
#  name              :string
#  starts_at         :datetime
#  city              :string
#  latitude          :float
#  longitude         :float
#  description       :text
#  visibility        :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  address           :string
#  creator_id        :integer
#  photo             :string
#  category_id       :integer
#  user_limit        :integer
#  min_age           :integer
#  max_age           :integer
#  gender            :string
#  sharing_token     :string
#  extra_category_id :integer
#  memberships_count :integer          default(0), not null
#

class Event < ActiveRecord::Base
  after_create :attend
  after_destroy :notify_users

  belongs_to :creator, class_name: 'User'
  belongs_to :category
  belongs_to :extra_category, class_name: 'Category'

  has_many :invites, dependent: :destroy
  has_many :invited_users, through: :invites, source: :user

  has_many :submissions, dependent: :destroy
  has_many :submitted_users, through: :submissions, source: :user

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_many :comments, dependent: :destroy

  validates :creator, presence: true
  validates :category, presence: true
  validates :starts_at, presence: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :city, presence: true
  validates :user_limit, numericality: { greater_than: 1 }, allow_nil: true
  validates :visibility, inclusion: { in: %w(public friends private) }
  validate :extra_category, :not_equal_to_category

  #  Filter validations
  validates :gender, inclusion: { in: %w(male female) }, allow_nil: true
  validates :min_age, numericality: { greater_than: 0 }, allow_nil: true
  validates :max_age, numericality: { less_than_or_equal_to: 100 }, allow_nil: true
  validates :min_age, numericality: { less_than_or_equal_to: :max_age },
                      if: 'max_age.present?', allow_nil: true
  validates :max_age, numericality: { greater_than_or_equal_to: :min_age },
                      if: 'min_age.present?', allow_nil: true

  mount_base64_uploader :photo, PhotoUploader

  has_secure_token :sharing_token

  geocoded_by :address

  scope :past_events, -> { where('ends_at < ?', Time.zone.now) }
  scope :upcoming, -> { where('starts_at >= ?', Time.zone.now) }
  scope :on_date, -> (date) { where(starts_at: (date.beginning_of_day)..(date.end_of_day)) }
  scope :public_events, -> { where(visibility: 'public') }
  scope :created_by_friends_of, -> (user) { where(creator: user.friends) }
  scope :not_private, -> { where(visibility: ['public', 'friends']) }

  def self.on_dates(dates)
    query = 'starts_at BETWEEN ? AND ?' + ' OR starts_at BETWEEN ? AND ?' * (dates.size - 1)
    dates.map! { |date| [date.beginning_of_day, date.end_of_day] }.flatten!
    Event.where(query, *dates)
  end

  def self.available_for(user)
    events = visible_by_friends_for(user)
    filled_event_ids = public_events.where('memberships_count = user_limit').ids
    participated_ids = joins(:memberships).where('memberships.user_id': user.id).ids
    ids = (events.ids + participated_ids + filled_event_ids).uniq
    where(id: ids)
  end

  def self.visible_for(user)
    events = allowed_for(user)
    created_by_friends_ids = created_by_friends_of(user).not_private.ids
    ids = (events.ids - created_by_friends_ids - user.owned_event_ids - user.event_ids).uniq
    where(id: ids)
  end

  def self.visible_by_friends_for(user)
    created_by_friends_ids = created_by_friends_of(user).not_private.ids
    events = allowed_for(user)
    ids = (events.ids + created_by_friends_ids).uniq
    where(id: ids)
  end

  def self.allowed_for(user)
    events = public_events
    events = events.where('gender IS NULL OR gender = ?', user.gender)
    events = events.where('min_age IS NULL OR min_age <= ?', user.age)
    events = events.where('max_age IS NULL OR max_age >= ?', user.age)
    events = events.where('user_limit IS NULL OR memberships_count < user_limit')
    where(id: events.ids)
  end

  def friend_count(current_user)
    users.where(id: current_user.friends.ids).count
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

  def to_location
    "#{latitude},#{longitude}"
  end

  private

  def not_equal_to_category
    return unless category && extra_category
    errors.add(:extra_category, "can't be equal to category") if category == extra_category
  end

  def attend
    creator.events << self
  end

  def notify_users
    users.each do |user|
      next unless user.notifications_events?
      options = { action: 'EVENT_DESTROYED', event: as_json }
      Notifier.new(user, "Событие удалено: #{self}", options)
    end
  end
end
