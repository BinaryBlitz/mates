class VKTest < ActiveSupport::TestCase
  setup do
    @vk = vk_client
  end

  test 'should create and find from vk token' do
    assert_difference 'User.count' do
      User.find_or_create_from_vk(@vk)
    end

    user = User.last
    assert_equal vk_user.uid, user.vk_id

    assert_no_difference 'User.count' do
      old_user = User.find_or_create_from_vk(@vk)
      assert_equal user, old_user
    end
  end

  private

  def vk_client
    users = stub(get: [vk_user])
    friends = stub(get: [])
    stub(users: users, token: 'token', friends: friends)
  end

  def vk_user
    stub(first_name: 'Foo', last_name: 'Bar', screen_name: 'FooBar', photo: nil, uid: 2)
  end
end
