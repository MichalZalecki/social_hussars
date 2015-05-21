Rails.application.routes.draw do
  get 'page/home'
  resources :questions, except: :destroy
  devise_for :users
  root 'questions#index'
end
