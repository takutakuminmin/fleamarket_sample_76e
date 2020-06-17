Rails.application.routes.draw do
  devise_for :users
  root "posts#index"
  resources :posts, only: [:index,:show]
  resources :items, only: [:new,:create]
  resources :mypages, only: [:index]
  resources :addresses, only: [:new, :create]
  resources :users, only: [:edit, :update]
  resources :cards, only: [:new, :show, :edit, :update, :create, :destroy]

  resources :purchases, only: [:index] do
    collection do
      get 'index', to: 'purchases#index'
      post 'pay', to: 'purchases#pay'
      get 'pay', to: 'purchases#pay'
      get 'done', to: 'purchases#done'
    end
  end

  # resources :posts do
  #   resources :purchases, only: [:index] do
  #     collection do
  #       get 'index', to: 'purchases#index'
  #       post 'pay', to: 'purchases#pay'
  #       get 'pay', to: 'purchases#pay'
  #       get 'done', to: 'purchases#done'
  #     end
  #   end
  # end
end
