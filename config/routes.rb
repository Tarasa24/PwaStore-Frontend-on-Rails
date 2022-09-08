# frozen_string_literal: true

Rails.application.routes.draw do
  get '/', to: 'index#get', as: 'index'
  get 'appdetail/:appID', to: 'app_detail#get', as: 'app_detail'
  post 'review/:appID', to: 'review#post', as: 'review'
  get 'reviews/:appID', to: 'review#get', as: 'reviews'
  get 'search', to: 'search#get', as: 'search'
  get 'author/:authorID', to: 'author#get', as: 'author'
end
