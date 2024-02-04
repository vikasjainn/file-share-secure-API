Rails.application.routes.draw do

  post '/upload', to: 'posts#create'
  get '/posts', to: 'posts#index'
  get '/posts/:id', to: 'posts#show'
  delete '/posts/:id', to: 'posts#destroy'
  
  post '/register', to: 'users#create'
  post '/login', to: 'authentication#login'
  post '/logout', to: 'authentication#logout'

  get '/users', to: 'users#index'
  get '/users/:id', to: 'users#show'
  delete '/users/:id', to: 'users#destroy'
end
