Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "static#home"

  namespace :api do
    resources :products
    get "/product-cards", to: "products#cards"
    resources :languages, only: [:index]
    resources :platforms, only: [:index]
    resources :sessions, only: [:create]
    delete :logout, to: "sessions#logout"
    get :logged_in, to: "sessions#logged_in"
    resources :registrations, only: [:create]
  end
  

end
