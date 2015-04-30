class FBTest < ActiveSupport::TestCase
  setup do
    @fb = fb_graph
  end

  test 'should create user from fb token' do
    assert_difference('User.count') do
      User.find_or_create_from_fb(@fb)
    end

    assert_no_difference 'User.count' do
      user = User.last
      old_fb_user = User.find_or_create_from_fb(@fb)
      assert_equal user, old_fb_user
    end
  end

  private

  def fb_graph
    Koala::Facebook::API.new("CAAE0WhYgLZC0BABmZA6WJ2FjVBSUtQrWhBzdTcWNGjHlTCO2MjZA6RgCj9ht9vgfkcdsYZA8BzZCRXJkMZCZCmAZCNwrIcg9Qh2tgPY988J95W3gtJ6JilPdhhBrEajIoCzQOYmzP7AiU2vga9aXpBk3eh8ZBv5uJhQHomE2jNqnR8zBdgZBGc9EKTGQySP4YGpSs39uyugw7CHyPCgn5RGCQmkzR1ALAZBFW0ZD")
  end
end
