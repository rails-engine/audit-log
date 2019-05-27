# frozen_string_literal: true

module AuditLog
  class Log < ActiveRecord::Base
    include AuditLog::Model
  end
end
