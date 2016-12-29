# == Schema Information
#
# Table name: social_tokens
#
#  id           :integer          not null, primary key
#  service_type :string
#  social_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class SocialToken < ApplicationRecord
  validates :service_type, inclusion: { in: %w(vk fb tw) }
  validates :social_id, presence: true

  def user
    User.find_by("#{service_type}_id": social_id)
  end

  def as_json(options)
    { id: user.try(:id), api_token: user.try(:api_token) }
  end
end
