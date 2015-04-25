# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  first_name :string
#  last_name  :string
#  nickname   :string
#  birthday   :date
#  gender     :boolean
#  api_token  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  avatar     :string
#

class User < ActiveRecord::Base
  before_create :generate_api_token

  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :nickname, presence: true, length: { maximum: 20 }

  has_many :friend_requests, dependent: :destroy
  has_many :pending_friends, through: :friend_requests, source: :friend

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  has_many :owned_events, dependent: :destroy, foreign_key: :admin_id, class_name: 'Event'

  has_many :memberships, dependent: :destroy
  has_many :events, through: :memberships

  has_many :proposals, dependent: :destroy
  has_many :proposed_events, through: :proposals, source: :event

  has_many :invites, dependent: :destroy
  has_many :invited_events, through: :invites, source: :event

  mount_base64_uploader :avatar, AvatarUploader

  def remove_friend(friend)
    friendships.find_by(friend: friend).destroy
    friend.friendships.find_by(friend: self).destroy
  end

  private

  def generate_api_token
    self.api_token = SecureRandom.hex
  end
end
