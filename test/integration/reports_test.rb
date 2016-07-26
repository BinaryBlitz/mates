require 'test_helper'

class ReportsTest < ActionDispatch::IntegrationTest
  test 'create' do
    post api_reports_path(api_token: api_token), params: {
      report: { content: 'Content' }
    }
  end
end
