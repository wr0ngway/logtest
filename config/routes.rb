Logtest::Application.routes.draw do
  resources :posts
  resources :actions
  root :to => "actions#index"
end
