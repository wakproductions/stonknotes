Rails.application.routes.draw do
  resources :stonknotes, only: [:index, :new, :create]
  post 'stonknotes', to: 'stonknotes#index'

  root to: 'home#index'
end
