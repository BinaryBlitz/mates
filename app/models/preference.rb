# == Schema Information
#
# Table name: preferences
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  notifications_friends :boolean          default(TRUE)
#  notifications_events  :boolean          default(TRUE)
#  visibility_photos     :string           default("public")
#  visibility_events     :string           default("public")
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Preference < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
end
