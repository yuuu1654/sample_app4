Rails.application.routes.draw do
  
  root 'static_pages#home'
  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup',  to: 'users#new'

  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy' 

  #多数の名前付きルート&アクションが利用できる
  #GET => /users/1/following
  #アクション => following
  #名前付きルート => following_user_path(1)
  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :account_activations, only: [:edit]

  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :microposts, only: [:create, :destroy]
  #POST /microposts microposts_path
  #DELETE /microposts/1 micropost_path(micropost)

  resources :relationships, only: [:create, :destroy]
end