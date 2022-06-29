# frozen_string_literal: true

require "test_helper"

module AuditLog
  class LogTest < ActiveSupport::TestCase
    test "initialize_payload_request" do
      log = AuditLog::Log.new
      assert_equal({}, log.request)
      assert_equal({}, log.payload)

      log = AuditLog::Log.new(payload: { foo: 1 })
      assert_equal({ "foo" => 1 }, log.payload)

      log = AuditLog::Log.new(request: { user_agent: "Hello world" })
      assert_equal({ "user_agent" => "Hello world" }, log.request)
    end

    test "create" do
      user = create(:user)
      topic = create(:topic)

      log = create(:log, action: "create_topic", record: topic, user: user,
                         payload: { id: topic.id, title: topic.title }, request: { ip: "0.0.0.0" })
      assert_equal false, log.new_record?

      assert_equal "create_topic", log.action
      assert_equal topic, log.record
      assert_equal user, log.user
      assert_equal topic.id, log.payload["id"]
      assert_equal topic.title, log.payload["title"]
      assert_equal "0.0.0.0", log.request["ip"]
    end
  end
end
