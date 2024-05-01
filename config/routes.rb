Rails.application.routes.draw do
  get 'users/index'
  get 'users/:id/show', to: 'users#show'
  devise_for :users, controllers: {
    registrations:  'users/registrations',
    sessions:       'users/sessions'
  }
  devise_scope :user do
    get '/', to: 'books#index'
    get '/users/password/new', to: 'users/password#new'
    get '/users/password/edit', to: 'users/password#edit'
    patch '/users/password', to: 'users/password#update'
  end

  resources :books, :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

end
