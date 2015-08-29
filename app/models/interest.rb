# == Schema Information
#
# Table name: interests
#
#  id          :integer          not null, primary key
#  category_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Interest < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  validates :user, presence: true
  validates :category, presence: true, uniqueness: { scope: :user }
end
