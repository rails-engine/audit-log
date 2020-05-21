# frozen_string_literal: true

module AuditLog
  class LogSubscriber < ActiveSupport::LogSubscriber
    # ActiveSupport::Notifications.instrument('audit.audit_log', action: action)
    def audit(event)
      prefix = color('AuditLog', CYAN)
      action = color(event.payload[:action], BLUE)
      debug "  #{prefix} #{action} (#{event.duration.round(1)}ms)"
    end
  end
end
