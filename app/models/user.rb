# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string
#  last_name       :string
#  nickname        :string
#  birthday        :date
#  gender          :boolean
#  api_token       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  avatar          :string
#  vk_id           :integer
#  facebook_id     :integer
#  password_digest :string
#  city            :string
#  phone_number    :string
#

class User < ActiveRecord::Base
  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :nickname, presence: true, length: { maximum: 20 }, unless: :oauth?
  validates :password, presence: true, length: { minimum: 6 }

  has_many :friend_requests, dependent: :destroy
  has_many :pending_friends, through: :friend_requests, source: :friend
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  has_many :owned_events, dependent: :destroy, foreign_key: :admin_id, class_name: 'Event'
  has_many :events, through: :memberships
  has_many :memberships, dependent: :destroy

  has_many :proposals, dependent: :destroy
  has_many :proposed_events, through: :proposals, source: :event
  has_many :invites, dependent: :destroy
  has_many :invited_events, through: :invites, source: :event

  has_many :comments, dependent: :destroy

  has_secure_password
  has_secure_token :api_token

  mount_base64_uploader :avatar, AvatarUploader

  phony_normalize :phone_number, default_country_code: 'RU'
  validates :phone_number, phony_plausible: true

  include Authenticable

  def self.from_events_participated_by(user)
    includes(:memberships)
    .where(memberships: { event_id: user.events })
    .where(memberships: { event_id: Event.past_events })
    .where.not(memberships: { user_id: user.friends })
    .where.not(memberships: { user_id: user })
    .distinct
    .pluck('id')
  end


  def remove_friend(friend)
    friendships.find_by(friend: friend).destroy
    friend.friendships.find_by(friend: self).destroy
  end

  private

  def oauth?
    vk_id || facebook_id
  end
end
