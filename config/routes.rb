Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :courses
      
      resources :students do
        collection do
          get :statistics
        end
      end
    end
  end
end