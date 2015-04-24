class PartyTest < ActiveSupport::TestCase
  def setup
    @party = parties(:foo)
  end

  test 'should be valid' do
    assert @party.valid?
  end

  test "name should be present" do
    @party.name = ""
    assert_not @party.valid?
  end

  test "target should be present" do
    @party.target = ""
    assert_not @party.valid?
  end

  test "at least it should have city" do
    @party.city = ""
    assert_not @party.valid?
  end

  test "name should be no longer than 30 characters" do
    @party.name = "a" * 31
    assert_not @party.valid?
  end

  test "target should be no longer than 20 characters" do
    @party.target = "a" * 21
    assert_not @party.valid?
  end

  test "city should be no longer than 30 characters" do
    @party.city = "a" * 31
    assert_not @party.valid?
  end
end