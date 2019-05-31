require_relative './audit-log/version'
require_relative './audit-log/configuration'
require_relative './audit-log/model'
require_relative './audit-log/engine'
require 'kaminari'

module AuditLog
  class << self
    def config
      return @config if defined?(@config)

      @config = Configuration.new
      @config.user_class = 'User'
      @config.current_user_method = 'current_user'
      @config.user_name_method = 'name'
      @config
    end

    def configure(&block)
      config.instance_exec(&block)
    end

    # Create an audit log
    #
    # AuditLog.audit!(:edit_account, @account, payload: account_params, user: current_user)
    def audit!(action, record = nil, payload: nil, user: nil, request: nil)
      request_info = {}
      if request
        request_info = {
          ip: request.ip,
          url: request.url,
          user_agent: request.user_agent
        }
      end

      AuditLog::Log.create!(
        action: action,
        record: record,
        payload: (payload || {}).to_h.deep_stringify_keys,
        user: user,
        request: request_info.deep_stringify_keys
      )
    end
  end
end
