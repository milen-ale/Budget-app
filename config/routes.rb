Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root 'budget_categories#index', as: :authenticated_root
  end

  root 'splash_screen#index'

  resources :budget_categories, except: :show do
    resources :expenses, except: :show
  end
end
