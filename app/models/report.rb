# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  user_id    :integer
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Report < ActiveRecord::Base
  belongs_to :user, optional: true
  belongs_to :event, optional: true
end
