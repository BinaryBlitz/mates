# == Schema Information
#
# Table name: invites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  accepted   :boolean
#

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

  test 'valid event date' do
    event = @invite.event
    event.starts_at = 1.day.ago

    assert @invite.invalid?
  end
end
