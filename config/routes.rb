Rails.application.routes.draw do
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
end
