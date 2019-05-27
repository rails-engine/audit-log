require_relative "./audit-log/version"
require_relative "./audit-log/configuration"
require_relative "./audit-log/engine"

module AuditLog
  class << self
    def config
      return @config if defined?(@config)
      @config = Configuration.new
      @config.user_class = "User"
      @config.current_user_method = "current_user"
      @config
    end

    def configure(&block)
      config.instance_exec(&block)
    end

    # Create audit log
    def audit!(action, payload: nil, user: nil, request: nil)
      request_info = {}
      if request
        request_info = {
          ip: request.ip,
          url: request.url,
          user_agent: request.user_agent,
        }
      end

      AuditLog::Log.create!(
        action: action,
        payload: payload || {},
        user: user,
        request: request_info
      )
    end
  end
end