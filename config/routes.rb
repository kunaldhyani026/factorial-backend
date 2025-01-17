Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :products
  resources :carts, only: [:index] do
    post 'add_item', on: :collection
  end
  resources :customizable_options
  resources :pricing_groups
end
