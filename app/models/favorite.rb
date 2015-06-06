# == Schema Information
#
# Table name: favorites
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  favorited_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorited, class_name: 'User'

  validates :user, presence: true
  validates :favorited, presence: true, uniqueness: { scope: :user }
  validate :not_self

  private

  def not_self
    errors.add(:favorited, "can't be equal to user") if favorited == user
  end
end
