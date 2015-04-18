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
#

class User < ActiveRecord::Base
  before_create :generate_api_token

  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :nickname, presence: true, length: { maximum: 20 }

  private

  def generate_api_token
    self.api_token = SecureRandom.hex
  end
end
