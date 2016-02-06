require 'test_helper'

class InviteTest < ActiveSupport::TestCase
  setup do
    @invite = invites(:invite)
  end

  test 'valid' do
    assert @invite.valid?
  end

  test 'uniqueness' do
    dup = @invite.dup
    assert dup.invalid?

    @invite.accept
    assert dup.invalid?

    @invite.event.users.destroy(@invite.user)
    assert dup.valid?
  end
end
