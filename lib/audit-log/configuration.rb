# frozen_string_literal: true

module AuditLog
  class Configuration
    # class name of you User model, default: 'User'
    attr_accessor :user_class

    # current_user method name in your Controller, default: 'current_user'
    attr_accessor :current_user_method

    # user name method, default: "name"
    attr_accessor :user_name_method

    # set a speicla table_name for AuditLog Model, default: 'audit_logs'
    attr_accessor :table_name
  end
end
