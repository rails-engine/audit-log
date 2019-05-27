# frozen_string_literal: true

module AuditLog
  class Log < ActiveRecord::Base
    self.table_name = "audit_logs"

    serialize :payload, Hash
    serialize :request, Hash

    belongs_to :user, class_name: AuditLog.config.user_class, required: false
    belongs_to :record, polymorphic: true, required: false

    validates :action, presence: true

    after_initialize :initialize_payload_request
    def initialize_payload_request
      self.payload = {} if payload.nil?
      self.request = {} if request.nil?
    end
  end
end
