Rails.application.routes.draw do
  root to: 'posts#index'
  post '/auth/sign_up', to: 'users#create'
  post '/auth/login', to: 'authentication#login'
  resources :posts, only: %i[index show create update destroy]
end
