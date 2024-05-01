Rails.application.routes.draw do
  get 'users/index'
  get 'users/:id/show', to: 'users#show'
  devise_for :users, controllers: {
    registrations:  'users/registrations', # カンマで区切るのを忘れない！
    sessions:       'users/sessions'
  }
  resources :books
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
