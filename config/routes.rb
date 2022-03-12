Rails.application.routes.draw do
  resources :room, only: [:create]
  post 'join', to: 'room#join'
end
