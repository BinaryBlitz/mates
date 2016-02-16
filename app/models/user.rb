# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  first_name            :string
#  last_name             :string
#  birthday              :date
#  gender                :string
#  api_token             :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  avatar                :string
#  city                  :string
#  phone_number          :string
#  visited_at            :datetime
#  avatar_original       :string
#  website_url           :string
#  notifications_friends :boolean          default(TRUE), not null
#  notifications_events  :boolean          default(TRUE), not null
#

class User < ActiveRecord::Base
  after_create :set_online

  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :gender, inclusion: { in: %w(male female) }, allow_nil: true
  validates :website_url, url: true, allow_nil: true

  # Preferences
  has_one :preference, dependent: :destroy
  accepts_nested_attributes_for :preference

  def preferences
    preference || create_preference
  end

  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true

  # Interests
  has_many :interests, dependent: :destroy
  has_many :categories, through: :interests
  accepts_nested_attributes_for :interests, allow_destroy: true

  has_many :friend_requests, dependent: :destroy
  has_many :incoming_friend_requests, class_name: 'FriendRequest', foreign_key: :friend_id
  has_many :pending_friends, through: :friend_requests, source: :friend
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  has_many :owned_events, dependent: :destroy, foreign_key: :creator_id, class_name: 'Event'
  has_many :memberships, dependent: :destroy
  has_many :events, through: :memberships

  has_many :proposals, dependent: :destroy
  has_many :proposed_events, through: :proposals, source: :event
  has_many :invites, dependent: :destroy

  has_many :submissions, dependent: :destroy
  has_many :submitted_events, through: :submissions, source: :event

  has_many :comments, dependent: :destroy
  has_many :mentions, class_name: 'Comment', foreign_key: :respondent_id

  has_many :device_tokens, dependent: :destroy
  has_many :searches, dependent: :destroy

  has_secure_token :api_token

  mount_base64_uploader :avatar, AvatarUploader

  phony_normalize :phone_number, default_country_code: 'RU'
  validates :phone_number, phony_plausible: true, presence: true

  def remove_friend(friend)
    friendships.find_by(friend: friend).destroy
    friend.friendships.find_by(friend: self).destroy
  end

  def friend_request_to_or_from(current_user)
    outgoing = friend_requests.find_by(friend: current_user)
    incoming = incoming_friend_requests.find_by(user: current_user)
    outgoing || incoming
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
    args.map! { |word| ["%#{word}%", "%#{word}%"] }.flatten!
    User.where(query, *args)
  end

  def pending_friend?(user)
    pending_friends.include?(user)
  end

  def friend?(user)
    friends.include?(user)
  end

  def age
    return 0 unless birthday
    today = Time.zone.today
    age = today.year - birthday.year
    age -= 1 if today < birthday + age.years
    age
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  def online?
    visited_at && visited_at > 1.minute.ago
  end

  def offer_count
    invites.unreviewed.count + Submission.where(event: owned_events).unreviewed.count
  end

  private

  def set_online
    touch(:visited_at)
  end
end
