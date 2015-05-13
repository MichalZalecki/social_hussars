Rails.application.routes.draw do
  get 'page/home'
  resources :questions
  devise_for :users
  root 'questions#index'
end
