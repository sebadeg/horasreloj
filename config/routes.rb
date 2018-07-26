Rails.application.routes.draw do
  resources :principal
  get root to: 'principal#index'
  
  post 'principal/entrar'
  post 'principal/salir'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
