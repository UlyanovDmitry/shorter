Rails.application.routes.draw do
  namespace :admin do
    resources :links, only: :create, param: :unique_key do
      get :stats, on: :member
    end
  end
  resources :links, only: :show, param: :unique_key
  # get ':unique_key', to: 'links#show', as: 'link'
  # resources :links, only: :show, param: :unique_key
end
