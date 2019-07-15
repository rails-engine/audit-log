require 'test_helper'

class AuditLogTest < ActiveSupport::TestCase
  test '.config' do
    assert_kind_of AuditLog::Configuration, AuditLog.config
    assert_equal 'User', AuditLog.config.user_class
    assert_equal 'custom_current_user', AuditLog.config.current_user_method
    assert_equal 'name', AuditLog.config.user_name_method
  end

  test 'audit!' do
    user = create(:user)
    record = create(:comment)
    request = ActionDispatch::Request.new(Rack::MockRequest.env_for('http://example.com:8080/test',
                                                          'REMOTE_ADDR' => '10.10.10.10',
                                                          'HTTP_USER_AGENT' => 'Fake agent'))
    log = AuditLog.audit!(:hello, record, payload: { name: 'Foo', status: 1 }, request: request, user: user)
    assert_equal false, log.new_record?

    log = AuditLog::Log.last
    assert_equal record, log.record
    assert_equal user, log.user
    assert_equal user.name, log.user_name
    assert_equal 'Foo', log.payload['name']
    assert_equal 1, log.payload['status']
    assert_equal '10.10.10.10', log.request['ip']
    assert_equal 'http://example.com:8080/test', log.request['url']
    assert_equal 'Fake agent', log.request['user_agent']
    assert_equal 'hello', log.action
    assert_equal 'Hello1', log.action_name
  end

  test 'audit! with default' do
    log = AuditLog.audit!(:hello)
    assert_equal false, log.new_record?

    log = AuditLog::Log.last
    assert_nil log.user
    assert_nil log.record
    assert_equal 'none', log.user_name
    assert_equal 'hello', log.action
    assert_equal({}, log.payload)
    assert_equal({}, log.request)
  end

  test 'audit! with JSON payload' do
    log = AuditLog.audit!(:hello, nil, payload: { 'name' => 'Foo' }.as_json)
    assert_equal false, log.new_record?

    log = AuditLog::Log.last
    assert_equal 'Foo', log.payload['name']
  end

  test 'audit! with ActionController::Parameters payload' do
    params = ActionController::Parameters.new(a: '123', b: '456')
    params.permit!
    log = AuditLog.audit!(:hello, nil, payload: params)
    assert_equal false, log.new_record?

    log = AuditLog::Log.last
    assert_equal '123', log.payload['a']
    assert_equal '456', log.payload['b']
  end

  test "action_options" do
    assert_equal [["List Audit Log", "list_audit_log"], ["Create Audit Log", "create_audit_log"], ["Update Audit Log", "update_audit_log"], ["Update Password", "update_password"], ["Hello1", "hello"], ["Visit Home", "home"]], AuditLog.action_options
  end
end
