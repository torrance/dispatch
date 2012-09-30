Dispatch::Application.routes.draw do
  ActiveAdmin.routes(self)

  root :to => 'frontpage#show'

  resources :articles, :controller => :contents, :type => "Article", :except => :index
  resources :events, :controller => :contents, :type => "Event", :except => :index
  resources :reposts, :controller => :contents, :type => "Repost", :except => :index

  resources :contents, :only => [] do
    resources :comments, :only => [:create, :update, :destroy]
    member do
      post 'vote/:vote' => 'moderate#vote', :as => :vote
      put 'hide/:hide' => 'moderate#hide', :as => :hide
    end
  end

  get 'submissions' => 'contents#index', :as => :submissions
  get 'submissions/:id' => 'contents#show', :hidden => 'true', :as => :submission

  resources :tags, :only => ['index']

  match 'content-filter/markdown' => 'content_filters#markdown'

  match 'search' => 'search#index', :as => :search

  # Login, logout and account validation
  get 'login' => 'users#new', :as => :login
  post 'login' => 'users#login', :as => :login
  match 'logout' => 'users#logout', :as => :logout
  get 'users/validate/:token' => 'users#validate', :as => :validate
  get 'users/:id/validate' => 'users#send_validation', :as => :send_validation

  # Reset passwords
  get 'users/reset' => 'forgotten_passwords#new', :as => :reset_password
  post 'users/reset' => 'forgotten_passwords#create', :as => :reset_password
  get 'users/reset/:token' => 'forgotten_passwords#reset', :as => :reset_password_token

  resources :users

  get ':path' => 'pages#show', :as => :page

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
