Rails.application.routes.draw do
  get 'page/home'
  resources :questions, except: :destroy do
    resources :answers, only: [:create]
  end
  devise_for :users
  root 'questions#index'
end
