Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check
  root "prescriptions#index"
  resources :medications do
    resources :dosages, only: [:index]
  end
  resources :prescriptions

  post 'calculations', to: 'calculations#index'
end
