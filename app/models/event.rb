# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  name       :string
#  target     :string
#  start_at   :datetime
#  end_at     :datetime
#  city       :string
#  latitude   :float
#  longitude  :float
#  info       :text
#  visible    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  address    :string
#

class Event < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 30 }
  validates :target, presence: true, length: { maximum: 20 }
  validates :city, presence: true, length: { maximum: 30 }
end
