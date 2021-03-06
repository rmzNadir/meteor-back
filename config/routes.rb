Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "static#home"

  namespace :api do
    resources :products
    get "/product-cards", to: "products#cards"
    resources :carts, only: [:show, :update]
    resources :sales
    get "/sales-dashboard", to: "sales#dashboard"
    get "/orders", to: "orders#index"
    get "/orders/:id", to: "orders#show"
    resources :users, except: [:create]
    resources :languages, only: [:index]
    resources :platforms, only: [:index]
    resources :sessions, only: [:create]
    get "/listings", to: "listings#index"
    get "/listings/:id", to: "listings#show"
    delete :logout, to: "sessions#logout"
    get :logged_in, to: "sessions#logged_in"
    resources :registrations, only: [:create]
  end
  

end
