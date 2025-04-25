Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :show]
      resource :session, only: [:create]
      resources :tasks, only: [:index, :create, :show, :update, :destroy]
    end
  end


# This allows Rails to handle CORS preflight requests
match '*path', via: :options, to: lambda { |_|
  [204, { 'Content-Type' => 'text/plain' }, []]
}
Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :show]
      resource :session, only: [:create]
      resources :tasks, only: [:index, :create, :show, :update, :destroy]
    end
  end

  # ✅ This allows Rails to handle CORS preflight requests
  match '*path', via: :options, to: lambda { |_|
    [204, { 'Content-Type' => 'text/plain' }, []]
  }
end
