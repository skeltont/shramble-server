Rails.application.routes.draw do
  # mount Rswag::Ui::Engine => '/api-docs'
  # mount Rswag::Api::Engine => '/api-docs'

  resources :room, only: [:create, :index]
  post 'join', to: 'room#join'

  resources :match, only: [:create, :new]
  post 'start', to: 'match#start'
  post 'end', to: 'match#end'

  resources :contestant, only: [:index]

  resources :result, only: [:create, :index]
  get 'standings', to: 'result#standings'
end
