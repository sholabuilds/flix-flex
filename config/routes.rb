Rails.application.routes.draw do
  resources :genres
   
    root "movies#index"
    get "movies/filter/:filter" => "movies#index", as: :filtered_movies

    # get "movies" => "movies#index"
    # get "movies/new" => "movies#new"
    # get "movies/:id" => "movies#show", as: "movie"
    # get "movies/:id/edit" => "movies#edit", as: "edit_movie"
    # patch "movies/:id" => "movies#update"
    resources :movies do
      resources :reviews
      resources :favourites
    end

    resources :users
    get "signup" => "users#new"

    resource :session, only: [:new, :create, :destroy]
    get "signin" => "sessions#new"
    delete "signout" => "sessions#destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
