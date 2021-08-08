Rails.application.routes.draw do
  resources :stonknotes, only: [:index, :new, :create] do
    collection do
      post 'load_more', to: 'stonknotes#index' # because Turbo will be submitting a form for load more action
    end
  end

  root to: 'home#index'
end
