RssReader::Application.routes.draw do

  resources :folders, :only => [:index, :new, :create, :edit, :destroy]

  post '/subscriptions/change_folder' => "subscriptions#change_folder", :as => :change_folder
  post '/subscriptions/unsubscribe' => "subscriptions#unsubscribe", :as => :unsubscribe
  get '/subscriptions/bookmarklet' => "subscriptions#bookmarklet"
  post '/subscriptions/subscribe' => "subscriptions#subscribe"

  resources :subscriptions, :only => [:index, :new, :create, :edit, :destroy]
  get "/subscribe/:url" => "feeds#subscribe", :as => :subscribe_from_url


  root to: 'welcome#index'

  get "/auth/:provider/callback" => "sessions#create"
  delete "/signout" => "sessions#destroy", :as => :signout

  resource :feeds do
    member do
      get 'import'
      post 'upload'
      get 'export'
      post 'subscribe'
    end
  end


  get '/setting' => "settings#show", :as => :setting
  patch '/setting' => "settings#update", :as => :setting_update
  get '/reader' => "reader#index", :as => :reader
  post '/reader/readed/:id' => "reader#readed"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root to: 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
