# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  # get '/rankings/:id', to: redirect('rankings/%{id}/songs')
  resources :rankings, except: [:show] do
    # get '/songs/:id', to: redirect('rankings/%{ranking_id}/songs/%{id}/submissions')
    resources :songs, except: [:show] do
      get 'export_csv', on: :collection
      resources :submissions do
        get 'export_csv', on: :collection
      end
    end
  end
  root 'home#index'
  get 'faqs', to: 'home#faqs'
  get 'release_notes', to: 'home#release_notes'
end
