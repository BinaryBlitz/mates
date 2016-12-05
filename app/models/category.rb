# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
  enum type: [
    :bar_or_club, :cafe, :cinema, :theater, :shows, :concert,
    :table_games, :active, :walk, :nature, :home, :other
  ]

  has_many :events, dependent: :destroy
  has_many :secondary_events, class_name: 'Event', foreign_key: 'extra_category_id'

  has_many :interests, dependent: :destroy
  has_many :users, through: :interests

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
