Rails.application.routes.draw do
  get 'principal/index'
  root 'principal#index'
  post 'principal/entrar'
  post 'principal/salir'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
