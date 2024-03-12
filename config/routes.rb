Rails.application.routes.draw do
  root 'tops#index'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  
  resources :users, only: %i[new create]
  resources :posts, only: %i[index new create show] do
    resources :comments, only: %i[create edit destroy], shallow: true
  end
  resources :saunas, only: %i[index show] do
    collection do
      get :search
    end
  end
end
