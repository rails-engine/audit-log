# frozen_string_literal: true

AuditLog.configure do
  # class name of you User model, default: 'User'
  # self.user_class = "User"
  # current_user method name in your Controller, default: 'current_user'
  # self.current_user_method = "current_user"
  # Speical a table_name for AuditLog model, default: "audit_logs"
  # self.table_name = "audit_logs"
end
