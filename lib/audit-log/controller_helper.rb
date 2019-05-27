module AuditLog
  module ControllerHelper
    # Create an audit log
    #
    # audit!(:edit_account, @account, payload: account_params)
    def audit!(action, record = nil, payload: nil, user: nil)
      user ||= self.send(AuditLog.config.current_user_method.to_sym)
      AuditLog.audit!(action, record, payload: payload, request: request, user: user)
    end
  end
end