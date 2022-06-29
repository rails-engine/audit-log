# frozen_string_literal: true

Rails.application.routes.draw do
  resources :comments
  resources :topics
  devise_for :users
  mount AuditLog::Engine => "/audit-log"
  root to: "welcome#index"
end
