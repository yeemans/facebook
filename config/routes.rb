Rails.application.routes.draw do
  resources :messages
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get '/auth/:provider/callback' => 'sessions#omniauth'
  
  root to: "posts#index"
  resources :users, only: [:index] do  

    member do  
      get 'notifications'
      get 'profile'
      get 'pfp_url'
      get 'chat'
      get 'friends'
      post 'chat'
      post 'change_pfp'
    end

    collection do 
      post 'friend_request'
      post 'process_request'
      get 'search'
      get 'index'
    end
    
  end
  
  resources :posts do 
    member do 
      resources :comments 
      get 'like'
    end
  end
  get "/search/person", to: "users#search_person"
  #post "/users/friend_request", to: "users#friend_request"
  #get "/users/:id/notifications", to: "users#notifications"
  get "/search", to: "users#search"
  #post "/users/process_request", to: "users#process_request"
  # redirect registration correctly
  #get 'dashboard', to: 'user#profile', :as => 'user_root'
  #get "/users/:id/profile", to: "users#profile"
  #get "/post", to: "posts#new"
  #post "/post", to: "posts#create"
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
