class Party < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 30 }
  validates :target, presence: true, length: { maximum: 20 }
  validates :city, presence: true, length: { maximum: 30 }
end
