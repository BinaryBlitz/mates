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
#  admin_id   :integer
#  photo      :string
#

class Event < ActiveRecord::Base
  belongs_to :admin, class_name: 'User'

  has_many :proposals, dependent: :destroy
  has_many :proposed_users, through: :proposals, source: :user

  validates :admin_id, presence: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :target, presence: true, length: { maximum: 20 }
  validates :city, presence: true, length: { maximum: 30 }

  mount_base64_uploader :photo, PhotoUploader
end
