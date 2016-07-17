require 'test_helper'

class DeviceTokensTest < ActionDispatch::IntegrationTest
  setup do
    @device_token = device_tokens(:ios)
  end

  test 'create device token' do
    assert_difference 'DeviceToken.count' do
      post api_device_tokens_path(api_token: api_token), params: {
        device_token: { token: 't', platform: 'ios' }
      }
    end
    assert_response :created
  end

  test 'destroy device token' do
    assert_difference 'DeviceToken.count', -1 do
      delete api_device_token_path(@device_token.token, api_token: api_token)
    end
    assert_response :no_content
  end
end
