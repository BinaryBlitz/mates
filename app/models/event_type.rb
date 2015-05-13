# == Schema Information
#
# Table name: event_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EventType < ActiveRecord::Base
  has_many :event_types, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
