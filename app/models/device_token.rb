# == Schema Information
#
# Table name: device_tokens
#
#  id         :integer          not null, primary key
#  token      :string
#  platform   :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DeviceToken < ActiveRecord::Base
  before_validation :ensure_uniqueness, on: :create

  validates :token, presence: true
  validates :user, presence: true
  validates :platform, presence: true

  belongs_to :user

  private

  def ensure_uniqueness
    device_token = DeviceToken.find_by(token: token)
    device_token.destroy if device_token
  end
end
