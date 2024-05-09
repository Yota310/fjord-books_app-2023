Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations:  'users/registrations',
    sessions:       'users/sessions'
  }
  get "/", to: 'books#index'
  resources :books
  resources :users, only: [:index, :show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

end
