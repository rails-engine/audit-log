# frozen_string_literal: true

require "test_helper"

class NavigationTest < ActionDispatch::IntegrationTest
  setup do
    @current_user = create(:user)
  end

  test "GET /audit-log" do
    get "/"
    assert_equal 200, response.status

    sign_in @current_user
    get "/comments/new"
    assert_equal 200, response.status

    comment = create(:comment)
    get "/comments/#{comment.id}"
    assert_equal 200, response.status

    assert AuditLog::Log.count > 2

    logs_count = AuditLog::Log.count

    get "/audit-log"
    assert_equal 200, response.status
    assert_select "tbody tr", count: logs_count

    get "/audit-log?q=comment"
    assert_select "tbody tr", count: 2
  end
end
