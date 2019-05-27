# frozen_string_literal: true

module AuditLog
  class LogsController < ActionController::Base
    layout "audit-log/application"
    before_action :set_log, only: %i[show destroy]

    def index
      @logs = Log.order("id desc").page(params[:page]).per(15)
    end

    def show; end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_log
        @log = Log.find(params[:id])
      end
  end
end
