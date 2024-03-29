Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  root 'tops#index'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  
  resources :users, only: %i[new create]
  resource :profile, only: %i[show edit update]
  resources :password_resets, only: %i[new create edit update]
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
