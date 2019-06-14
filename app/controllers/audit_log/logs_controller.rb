# frozen_string_literal: true

module AuditLog
  class LogsController < ActionController::Base
    layout 'audit-log/application'
    before_action :set_log, only: %i[show destroy]

    def index
      @logs = Log.order('id desc').includes(:user)
      @logs = @logs.where('action like ?', "%#{params[:q]}%") if params[:q].present?
      @logs = @logs.where("action = ?", params[:action_type]) if params[:action_type].present?
      @logs = @logs.where("created_at >= ?", Time.parse(params[:start_time])) if params[:start_time].present?
      @logs = @logs.where("created_at < ?", Time.parse(params[:end_time])) if params[:end_time].present?
      @logs = @logs.page(params[:page]).per(15)
    end

    def show; end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_log
      @log = Log.find(params[:id])
    end
  end
end
