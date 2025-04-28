Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :show]
      resource :session, only: [:create]
      resources :tasks, only: [:index, :create, :show, :update, :destroy]
    end
  end

  match '*path', to: 'application#preflight', via: [:options]
end
