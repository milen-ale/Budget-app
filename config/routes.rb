Rails.application.routes.draw do
  unauthenticated do
    root 'splash_screen#index'
  end

   devise_for :users
   
   root 'budget_categories#index', as: "categorytrack"
  resources :users

  resources :budget_categories do
    resources :expenses
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
 
end
