Rails.application.routes.draw do
  # unauthenticated do
  #   root "home#index"
  # end

  devise_for :users

  get '/categorytrack'=> "budget_categories#index"

  # resources :users

  # resources :budget_categories, only: [:index, :show, :new, :create, :destroy] do
  #   resources :expenses, only: [ :new, :show, :create, :destroy]
  # end

  resources :users do
   resources :budget_categories, only: [:index, :show, :new, :create, :destroy] do
     resources :expenses, only: [ :new, :show, :create, :destroy]
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  devise_scope :user do
  root 'splash_screen#index'
  end
end
