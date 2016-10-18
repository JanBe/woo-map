Rails.application.routes.draw do
  resources :sessions, only: [:index]
  get 'pages/map'

  root to: 'pages#map'
end
