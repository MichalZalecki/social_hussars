Rails.application.routes.draw do

  # We need to define devise_for just omniauth_callbacks:auth_callbacks otherwise it does not work with scoped locales
  # see https://github.com/plataformatec/devise/issues/2813
  devise_for :users, skip: [:session, :password, :registration, :confirmation], controllers: { omniauth_callbacks: 'callbacks' }


  scope "(:locale)", locale: /en|pl/ do
    get 'page/home'
    get 'page/leaderboard'
    resources :questions, except: :destroy do
      resources :answers, only: [:create] do
        post 'upvote'
        post 'downvote'
      post 'accept'
      end
    end

    # We define here a route inside the locale thats just saves the current locale in the session
    get 'omniauth/:provider' => 'omniauth#localized', as: :localized_omniauth

    devise_for :users, skip: :omniauth_callbacks

    resources :users, only: [:show]
    get '/:locale' => 'questions#index'
    root 'questions#index'

  end
end
