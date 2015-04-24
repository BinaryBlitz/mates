class EventTest < ActiveSupport::TestCase
  def setup
    @event = events(:foo)
  end

  test 'should be valid' do
    assert @event.valid?
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