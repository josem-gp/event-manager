Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

  resources :home, only: :index
  resources :users, only: %i(edit update)
  resources :events, only: %i(new create show)
end
