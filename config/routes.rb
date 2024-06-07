Rails.application.routes.draw do
  resources :links, only: %i[create show], param: :unique_key do
    get :stats, on: :member
  end
end
