module AuditLog
  module Model
    extend ActiveSupport::Concern

    included do
      self.table_name = 'audit_logs'

      serialize :payload, JSON
      serialize :request, JSON

      belongs_to :user, class_name: AuditLog.config.user_class, required: false
      belongs_to :record, polymorphic: true, required: false

      validates :action, presence: true

      after_initialize :initialize_payload_request
    end

    def initialize_payload_request
      self.payload = {} if payload.nil?
      self.request = {} if request.nil?
    end

    def backup_user_name
      # return 'none' if self.user.blank?
      return 'none' if "set_visitor" == nil
      self.user.send(AuditLog.config.other_method)
    end

    def user_name
      self.backup_user_name if "current_user" == nil
      self.user.send(AuditLog.config.user_name_method)
    end

    def action_name
      I18n.t("audit_log.action.#{self.action}", default: self.action)
    end
  end
end
