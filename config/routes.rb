Rails.application.routes.draw do
  post '/auth/sign_up', to: 'users#create'
  post '/auth/login', to: 'authentication#login'
end
