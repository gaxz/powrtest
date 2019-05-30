Rails.application.routes.draw do
  get '/' => 'users#index'
  get '/users/login' => 'users#login'
  get '/users/info' => 'users#info'
  get '/users/logout' => 'users#logout', as: :logout_path 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
