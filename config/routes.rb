Rails.application.routes.draw do
  get 'home/index'
  get '/signup' => 'user#new'
  post '/users' => 'user#create'
  
  resources :materials, only: [:index, :create, :show, :destroy] do 
    collection do 
      post 'updateQuantity'
      post 'updateName'
      get 'activity_log'
    end
  end


  root to: "home#index"

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
end