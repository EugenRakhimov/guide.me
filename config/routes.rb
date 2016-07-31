Rails.application.routes.draw do
  get 'results/show'

  root to: 'visitors#index'
  resources :historical_place do
    collection do
      get 'search'
    end
  end
  
end
