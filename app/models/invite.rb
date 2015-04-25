class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :user, presence: true
  validates :event, presence: true

  def accept
    # Destroy invite and create association
  end
end
