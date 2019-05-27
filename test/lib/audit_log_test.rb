require 'test_helper'

class AuditLogTest < ActiveSupport::TestCase
  test '.config' do
    assert_kind_of AuditLog::Configuration, AuditLog.config
    assert_equal 'User', AuditLog.config.user_class
    assert_equal 'current_user', AuditLog.config.current_user_method
  end

  test "audit!" do

  end
end
