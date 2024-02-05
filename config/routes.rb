Rails.application.routes.draw do
require 'sidekiq/web'
mount Sidekiq::Web => '/sidekiq'

  get '/users/me', to: 'users#showCurrentUser'
  delete '/todos/deleteAll', to: 'todos#deleteAll'
  post '/session', to: 'users#createSession'

  resources :todos

  resources :users

end
