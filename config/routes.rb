Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/users/sign_out' => 'devise/sessions#destroy'
  root 'posts#index'
  resources :posts, :except => [:index]

end
