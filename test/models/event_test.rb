# == Schema Information
#
# Table name: events
#
#  id            :integer          not null, primary key
#  name          :string
#  starts_at     :datetime
#  ends_at       :datetime
#  city          :string
#  latitude      :float
#  longitude     :float
#  info          :text
#  visibility    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  address       :string
#  admin_id      :integer
#  photo         :string
#  event_type_id :integer
#  user_limit    :integer          default(1)
#  min_age       :integer
#  max_age       :integer
#  gender        :string(1)
#

class EventTest < ActiveSupport::TestCase
  def setup
    @event = events(:party)
  end

  test 'should be valid' do
    assert @event.valid?
  end

  test 'admin_id should be present' do
    @event.admin_id = nil
    assert_not @event.valid?
  end

  test 'name should be present' do
    @event.name = ''
    assert_not @event.valid?
  end

  test 'target should be present' do
    @event.event_type = nil
    assert_not @event.valid?
  end

  test 'at least it should have city' do
    @event.city = ''
    assert_not @event.valid?
  end

  test 'name should be no longer than 30 characters' do
    @event.name = 'a' * 31
    assert_not @event.valid?
  end

  test 'city should be no longer than 30 characters' do
    @event.city = 'a' * 31
    assert_not @event.valid?
  end

  test 'user limit should be positive' do
    @event.user_limit = -1
    assert_not @event.valid?

    @event.user_limit = 0
    assert_not @event.valid?
  end

  test 'age filters' do
    @event.min_age = nil
    @event.max_age = nil
    assert @event.valid?

    @event.min_age = nil
    @event.max_age = 42
    assert @event.valid?

    @event.min_age = 42
    @event.max_age = nil
    assert @event.valid?

    @event.min_age = 1
    @event.max_age = 42
    assert @event.valid?

    @event.min_age = 64
    @event.max_age = 42
    assert @event.invalid?
  end

  test 'gender filter' do
    @event.gender = nil
    assert @event.valid?

    @event.gender = 'm'
    assert @event.valid?

    @event.gender = 'Hello'
    assert @event.invalid?

    @event.gender = ''
    assert @event.invalid?
  end

  test 'gender validation' do
    @event.gender = nil
    assert @event.valid_gender?(nil)
    assert @event.valid_gender?('f')

    @event.gender = 'f'
    assert_not @event.valid_gender?(nil)
    assert_not @event.valid_gender?('m')
  end
end
