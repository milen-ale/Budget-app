Rails.application.routes.draw do
  unauthenticated do
    root "home#index"
  end

  devise_for :users

  root 'budget_categories#index', as: "categorytrack"

  resources :users

  resources :budget_categories, only: [:index, :show, :new, :create, :destroy] do
    resources :expenses, only: [ :new, :show, :create, :destroy]
  end
end
