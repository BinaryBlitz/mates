# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  name       :string
#  target     :string
#  starts_at  :datetime
#  ends_at    :datetime
#  city       :string
#  latitude   :float
#  longitude  :float
#  info       :text
#  visibility :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  address    :string
#  admin_id   :integer
#  photo      :string
#

class EventTest < ActiveSupport::TestCase
  def setup
    @event = events(:party)
  end

  test "should be valid" do
    assert @event.valid?
  end

  test "admin_id should be present" do
    @event.admin_id = nil
    assert_not @event.valid?
  end

  test "name should be present" do
    @event.name = ""
    assert_not @event.valid?
  end

  test "target should be present" do
    @event.target = ""
    assert_not @event.valid?
  end



  test "at least it should have city" do
    @event.city = ""
    assert_not @event.valid?
  end

  test "name should be no longer than 30 characters" do
    @event.name = "a" * 31
    assert_not @event.valid?
  end

  test "target should be no longer than 20 characters" do
    @event.target = "a" * 21
    assert_not @event.valid?
  end

  test "city should be no longer than 30 characters" do
    @event.city = "a" * 31
    assert_not @event.valid?
  end
end
