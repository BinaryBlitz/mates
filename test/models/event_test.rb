# == Schema Information
#
# Table name: events
#
#  id                :integer          not null, primary key
#  name              :string
#  starts_at         :datetime
#  city              :string
#  latitude          :float
#  longitude         :float
#  description       :text
#  visibility        :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  address           :string
#  creator_id        :integer
#  photo             :string
#  category_id       :integer
#  user_limit        :integer          default(1)
#  min_age           :integer
#  max_age           :integer
#  gender            :string
#  sharing_token     :string
#  extra_category_id :integer
#

class EventTest < ActiveSupport::TestCase
  def setup
    @event = events(:party)
  end

  test 'should be valid' do
    assert @event.valid?
  end

  test 'extra category' do
    @event.extra_category = @event.category
    assert @event.invalid?

    @event.extra_category = nil
    assert @event.valid?

    @event.extra_category = categories(:movie)
    assert @event.valid?
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

  # TODO: Use enumerations
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

  test 'on_date scope' do
    date = @event.starts_at.to_date
    events = Event.on_date(date)
    assert_includes events, @event
  end

  test 'on_dates scope' do
    dates = [@event.starts_at.to_date]
    events = Event.on_dates(dates)
    assert_includes events, @event
  end
end
