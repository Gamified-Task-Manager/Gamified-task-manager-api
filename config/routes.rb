Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :show]
      resource :session, only: [:create]
      resources :tasks, only: [:index, :create, :show, :update, :destroy]
    end
  end

  # ✅ This catches OPTIONS requests for CORS
  match '*path', via: :options, to: ->(_) { [204, { 'Content-Type' => 'text/plain' }, []] }
end
