# frozen_string_literal: true

require "rails/generators"
module AuditLog
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Create AuditLog's base files"
      source_root File.expand_path("../../..", __dir__)

      def add_initializer
        template "config/initializers/audit-log.rb", "config/initializers/audit-log.rb"
      end

      def add_migrations
        exec("rake audit_log:install:migrations")
      end
    end
  end
end
