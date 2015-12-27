# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string
#  last_name       :string
#  birthday        :date
#  gender          :string           default("m")
#  api_token       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  avatar          :string
#  password_digest :string
#  city            :string
#  phone_number    :string
#  visited_at      :datetime
#  avatar_original :string
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:foo)
  end

  test 'search by name' do
    result = User.search_by_name(@user.first_name)
    assert result.include?(@user)

    result = User.search_by_name(@user.last_name)
    assert result.include?(@user)
  end

  test 'search should handle incorrect input' do
    result = User.search_by_name([])
    assert result.empty?

    result = User.search_by_name('')
    assert result.empty?

    result = User.search_by_name(nil)
    assert result.empty?
  end

  test 'gender' do
    @user.gender = nil
    @user.password = 'foobar'
    assert @user.valid?

    @user.gender = 'm'
    assert @user.valid?

    @user.gender = 'Hello'
    assert @user.invalid?

    @user.gender = ''
    assert @user.invalid?
  end

  test 'invalid without phone number' do
    @user.phone_number = nil
    assert @user.invalid?
  end
end
