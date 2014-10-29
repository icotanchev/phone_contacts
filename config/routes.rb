Rails.application.routes.draw do
  resources :file_operations

  root "contacts#index"
  resources :contacts do
  	collection do
  		get :import
  		post :import
      get :remove_dub
  	end
  end

  devise_for :users
  resources :users

  authenticate :user do
		mount Resque::Server, :at => '/resque'
	end
end
