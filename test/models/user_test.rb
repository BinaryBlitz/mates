# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  first_name :string
#  last_name  :string
#  nickname   :string
#  birthday   :date
#  gender     :boolean
#  api_token  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:foo)
  end
end
