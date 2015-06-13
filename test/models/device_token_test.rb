require 'test_helper'

class DeviceTokenTest < ActiveSupport::TestCase
  setup do
    @device_token = device_tokens(:ios)
  end

  test 'validates uniqueness' do
    new_token = @device_token.dup
    assert new_token.valid?

    new_token.save
    assert_not DeviceToken.exists?(id: @device_token.id)
    assert_equal @device_token.token, new_token.token
  end

  test 'allows only ios and android tokens' do
    assert @device_token.valid?

    @device_token.platform = 'windows phone'
    assert @device_token.invalid?
  end
end
