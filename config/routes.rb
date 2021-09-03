Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post '/users', to: 'users#create'

  post '/login', to: 'application#login' 

  get '/beers_names', to: 'beers#index_names'
  get '/beers', to: 'beers#index'

  get '/user_beers', to: 'user_beers#index'
  post '/create_user_beer', to: 'user_beers#create'
  post '/edit_or_create_usergrade', to: 'user_beers#edit_or_create'
end
