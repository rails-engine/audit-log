require_relative './controller_helper'

module AuditLog
  class Engine < Rails::Engine
    isolate_namespace AuditLog

    ActiveSupport.on_load(:action_controller) do
      prepend AuditLog::ControllerHelper
    end
end
