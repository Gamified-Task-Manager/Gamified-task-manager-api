Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :show]
      resource :session, only: [:create]
      resources :tasks, only: [:index, :create, :show, :update, :destroy]
      resources :rewards, only: [:index, :show]
      resources :user_rewards, only: [:index, :create, :update]
    end
  end

  match '*path', to: 'application#preflight', via: [:options]
end
