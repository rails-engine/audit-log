module AuditLog
  module ControllerHelper
    def audit!(action, payload: nil, user: nil)
      AuditLog.audit!(action, payload: payload, request: request, user: user)
    end
  end
end