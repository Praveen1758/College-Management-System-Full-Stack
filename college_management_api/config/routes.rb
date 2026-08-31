Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth/register", to: "auth#register"
      post "auth/login", to: "auth#login"

      resources :courses
      resources :enrollments, only: [ :create ]

      resources :students do
        collection do
          get :statistics
        end
      end
    end
  end
end
