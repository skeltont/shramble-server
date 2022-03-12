Rails.application.routes.draw do
  resources :room, only: [:create, :index]
  post 'join', to: 'room#join'

  resources :match, only: [:create]
end
