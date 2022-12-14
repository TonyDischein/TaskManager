Rails.application.routes.draw do
  root :to => "web/boards#show"

  scope module: :web do
    resource :board, only: :show
    resource :session, only: [:new, :create, :destroy]
    resource :password_reset, only: [:new, :create, :edit, :update]
    resources :developers, only: [:new, :create]
  end

  namespace :admin do
    resources :users
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :tasks, only: [:index, :show, :create, :update, :destroy] do
        member do
          put 'attach_image'
          delete 'remove_image'
        end
      end

      resources :users, only: [:index, :show]
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount Sidekiq::Web => '/admin/sidekiq'
end
