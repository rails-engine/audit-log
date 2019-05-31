# frozen_string_literal: true

AuditLog::Engine.routes.draw do
  resources :logs, path: ''
end
