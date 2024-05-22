Rails.application.routes.draw do
  resources :shortened_urls,
            path: :urls,
            only: %i[create show],
            controller: :shortened_urls,
            param: :unique_key

  get 'urls/:unique_key/stats', to: 'shortened_urls#stats', as: 'shortened_url_stats'
end
