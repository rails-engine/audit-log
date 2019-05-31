require_relative './controller_helper'

module AuditLog
  class Engine < Rails::Engine
    isolate_namespace AuditLog

    ActiveSupport.on_load(:action_controller_base) do
      prepend AuditLog::ControllerHelper
    end
  end
end
