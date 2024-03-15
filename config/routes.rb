Rails.application.routes.draw do
  root 'tops#index'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  
  resources :users, only: %i[new create]
  resources :posts do
    resources :comments, only: %i[create destroy], shallow: true
    collection do
      get :likes
    end
  end
  resources :likes, only: %i[create destroy]
  resources :saunas, only: %i[index show] do
    collection do
      get :search
    end
  end
end
