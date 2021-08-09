Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'beers#index'
  get 'beers', to: 'beers#index'
end
