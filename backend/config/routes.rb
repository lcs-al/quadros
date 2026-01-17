Rails.application.routes.draw do
  post '/auth/login', to: 'auth#login'
  post '/auth/signup', to: 'auth#signup'

  resources :boards do
    resources :memberships, controller: 'board_memberships', only: [:index, :create, :update, :destroy]
    
    resources :columns, only: [:create, :update, :destroy] do
      member do
        patch :move
      end
    end
  end

  resources :cards, only: [:create, :show, :update, :destroy] do
    member do
      patch :move
      post :restore
    end
    resources :comments, only: [:create, :update, :destroy]
  end

  resources :users, only: [:index] do
    collection do
      get :me
      patch :update_profile
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
