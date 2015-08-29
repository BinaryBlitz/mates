class FBTest < ActiveSupport::TestCase
  test 'should create user from fb token' do
    graph = stub("my graph")
    graph.stubs(:get_object).returns(
      "first_name" => 'NewFoo',
      "last_name" => 'NewBar',
      "name" => 'NewFooBar',
      "picture" => { "data" => { "url" => nil}},
      "id" => 12,
      "email" => 'test@facebook.com',
      "link" => 'https://www.facebook.com/zuck'
    )

    assert_difference('User.count') do
      User.find_or_create_from_fb(graph)
    end

    assert_no_difference 'User.count' do
      user = User.last
      old_fb_user = User.find_or_create_from_fb(graph)
      assert_equal user, old_fb_user
    end
  end
end
