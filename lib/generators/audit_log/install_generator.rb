# frozen_string_literal: true

require 'rails/generators'
module AuditLog
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Create AuditLog's base files"
      source_root File.expand_path('../../..', __dir__)

      def add_initializer
        template 'config/initializers/audit-log.rb', 'config/initializers/audit-log.rb'
        template 'config/locales/audit-log.yml', 'config/locales/audit-log.yml'
        template 'app/assets/stylesheets/audit-log/application.css', 'app/assets/stylesheets/audit-log/application.css'
        template 'app/controllers/audit_log/logs_controller.rb', 'app/controllers/audit_log/logs_controller.rb'
        template 'app/views/audit_log/logs/index.html.erb', 'app/views/audit_log/logs/index.html.erb'
        template 'app/views/audit_log/logs/show.html.erb', 'app/views/audit_log/logs/show.html.erb'
        template 'app/views/layouts/audit-log/application.html.erb', 'app/views/layouts/audit-log/application.html.erb'
      end

      def add_migrations
        exec('rake audit_log:install:migrations')
      end
    end
  end
end
