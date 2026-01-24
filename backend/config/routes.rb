Rails.application.routes.draw do
  post '/auth/login', to: 'auth#login'
  post '/auth/signup', to: 'auth#signup'

  resources :boards do
    resources :memberships, controller: 'board_memberships', only: %i[index create update destroy]
    resource :backlog, only: [:show]

    resources :columns, only: %i[create update destroy] do
      member do
        patch :move
      end
    end
    member do
      post 'conclude_cards'
    end
  end

  resources :cards, only: %i[create show update destroy] do
    member do
      patch :move
      post :restore
    end
    collection do
      post :bulk_move
    end
    resources :comments, only: %i[create update destroy]
  end

  resources :users, only: [:index] do
    collection do
      get :me
      patch :update_profile
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
