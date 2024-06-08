Rails.application.routes.draw do
  devise_for(
    :users, path: '', path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    }, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }
  )
  namespace :admin do
    resources :links, only: :create, param: :unique_key do
      get :stats, on: :member
    end
  end
  resources :links, only: :show, param: :unique_key
end
