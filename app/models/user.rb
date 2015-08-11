# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string
#  last_name       :string
#  birthday        :date
#  gender          :string           default("m")
#  api_token       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  avatar          :string
#  vk_id           :integer
#  facebook_id     :integer
#  password_digest :string
#  city            :string
#  phone_number    :string
#  vk_url          :string
#  facebook_url    :string
#  twitter_url     :string
#  instagram_url   :string
#  visited_at      :datetime
#  email           :string
#  avatar_original :string
#

class User < ActiveRecord::Base
  after_create :set_online

  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :email, email: true, uniqueness: true, allow_blank: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :gender, length: { is: 1 }, inclusion: { in: %w(f m) }, allow_nil: true

  validates :vk_url, url: { allow_blank: true }
  validates :facebook_url, url: { allow_blank: true }
  validates :twitter_url, url: { allow_blank: true }
  validates :instagram_url, url: { allow_blank: true }

  has_one :feed, dependent: :destroy

  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true

  has_many :friend_requests, dependent: :destroy
  has_many :pending_friends, through: :friend_requests, source: :friend
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :favorited

  has_many :inverse_favorites, class_name: 'Favorite', foreign_key: :favorited_id
  has_many :followers, through: :inverse_favorites, source: :user

  has_many :owned_events, dependent: :destroy, foreign_key: :admin_id, class_name: 'Event'
  has_many :memberships, dependent: :destroy
  has_many :events, through: :memberships

  has_many :proposals, dependent: :destroy
  has_many :proposed_events, through: :proposals, source: :event
  has_many :invites, dependent: :destroy
  has_many :invited_events, through: :invites, source: :event

  has_many :submissions, dependent: :destroy
  has_many :submitted_events, through: :submissions, source: :event

  has_many :comments, dependent: :destroy
  has_many :device_tokens, dependent: :destroy

  has_many :messages, -> (object) { where('creator_id = ? OR user_id = ?', object.id, object.id) }
  has_many :incoming_messages, class_name: 'Message'
  has_many :outgoing_messages, class_name: 'Message', foreign_key: 'creator_id'

  has_secure_password
  has_secure_token :api_token

  mount_base64_uploader :avatar, AvatarUploader

  # phony_normalize :phone_number, default_country_code: 'RU'
  # validates :phone_number, phony_plausible: true

  include Authenticable

  def remove_friend(friend)
    friendships.find_by(friend: friend).destroy
    friend.friendships.find_by(friend: self).destroy
  end

  def self.search_by_name(query)
    return User.none if !query.is_a?(String) || query.empty?

    args = query.strip.split
    if args.size > 0
      fuzzy_search_by_name(args)
    else
      User.None
    end
  end

  def self.fuzzy_search_by_name(args)
    query =
      'first_name ILIKE ? OR last_name ILIKE ?' +
      ' OR first_name ILIKE ? OR last_name ILIKE ?' * (args.size - 1)
    args.map! { |w| ["%#{w}%", "%#{w}%"] }.flatten!
    User.where(query, *args)
  end

  def favorite?(user)
    favorited_users.include?(user)
  end

  def pending_friend?(user)
    pending_friends.include?(user)
  end

  def friend?(user)
    friends.include?(user)
  end

  def age
    return 0 unless birthday

    age = Time.zone.today.year - birthday.year
    age -= 1 if Time.zone.today < birthday + age.years
    age
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  def notify_message(message, sender)
    Notifier.new(self, message, action: 'MESSAGE', sender: sender.as_json).push
  end

  def online?
    visited_at && visited_at > 1.minute.ago
  end

  private

  def set_online
    touch(:visited_at)
  end

  def oauth?
    vk_id || facebook_id
  end
end
