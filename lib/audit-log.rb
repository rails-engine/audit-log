# frozen_string_literal: true

require_relative "./audit-log/version"
require_relative "./audit-log/configuration"
require_relative "./audit-log/model"
require_relative "./audit-log/log_subscriber"
require_relative "./audit-log/engine"
require "kaminari"

module AuditLog
  class << self
    def config
      return @config if defined?(@config)

      @config = Configuration.new
      @config.user_class = "User"
      @config.current_user_method = "current_user"
      @config.user_name_method = "name"
      @config.table_name = "audit_logs"
      @config
    end

    def configure(&block)
      config.instance_exec(&block)
    end

    # Create an audit log
    #
    # AuditLog.audit!(:edit_account, @account, payload: account_params, user: current_user)
    def audit!(action, record = nil, payload: nil, user: nil, request: nil)
      ActiveSupport::Notifications.instrument("audit.audit_log", action: action) do
        request_info = {}
        if request
          request_info = {
            request_id: request.request_id,
            ip: request.remote_ip,
            url: request.url,
            user_agent: request.user_agent
          }
        end

        # Set nil if record is a new_record, do this for avoid create record.
        record = nil if record&.new_record?

        Rails.logger.silence do
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

    # Get I18n action name options for select
    def action_options
      I18n.t("audit_log.action").map { |k, v| [v, k.to_s] }
    end
  end
end
