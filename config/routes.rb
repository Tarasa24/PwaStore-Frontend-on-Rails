# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/', to: 'index#get', as: 'index'
  get 'AppDetail/:appID', to: 'app_detail#get', as: 'app_detail'
  post 'Review/:appID', to: 'review#post', as: 'review'
  get 'Reviews/:appID', to: 'review#get', as: 'reviews'
  get 'Search', to: 'search#get', as: 'search'
  get 'Author/:authorID', to: 'author#get', as: 'author'
end
