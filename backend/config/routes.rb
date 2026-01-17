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

  get "up" => "rails/health#show", as: :rails_health_check
end
