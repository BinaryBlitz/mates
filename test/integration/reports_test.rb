require 'test_helper'

class ReportsTest < ActionDispatch::IntegrationTest
  test 'create' do
    post '/api/reports', api_token: api_token, report: { content: 'Content' }
  end
end
