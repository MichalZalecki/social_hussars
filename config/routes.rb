Rails.application.routes.draw do
  get 'page/home'
  get 'page/leaderboard'
  resources :questions, except: :destroy do
    resources :answers, only: [:create] do
      post 'upvote'
      post 'downvote'
      post 'accept'
    end
  end
  devise_for :users
  root 'questions#index'
end
