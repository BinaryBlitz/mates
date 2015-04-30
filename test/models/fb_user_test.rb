class FBTest < ActiveSupport::TestCase
  setup do
    @fb = fb_graph
  end

  # test 'should create user from fb token' do
  #   assert_difference('User.count') do
  #     User.find_or_create_from_fb(@fb)
  #   end

  #   assert_no_difference 'User.count' do
  #     user = User.last
  #     old_fb_user = User.find_or_create_from_fb(@fb)
  #     assert_equal user, old_fb_user
  #   end
  # end

  private

  def fb_graph
    # Stub
  end
end
