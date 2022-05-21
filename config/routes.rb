# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', skip: %i[registrations token_validations passwords confirmations]
  resources :categories, except: %i[show]
  resources :projects
  resources :projects_users, only: %i[create destroy]
  resources :tasks do
    collection do
      post :search
    end
  end
  resources :users, only: %i[destroy]
end
