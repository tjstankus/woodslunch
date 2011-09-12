Woodslunch::Application.routes.draw do

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

  devise_for :users
  resources :users do
    resources :orders, :controller => 'user_orders'
  end

  resources :accounts do
    resources :users
    resources :students
    resources :payments
  end

  resources :menu_items
  resources :days_off
  resources :reports, :only => [:index]

  resources :account_requests, :only => [:index, :new, :create, :destroy] do
    member do
      post 'approve'
      post 'decline'
    end
    resources :activations, :controller => 'account_activations', :only => [:new, :create]
  end

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

  # match '/students/:student_id/orders/:year/:month' => 'student_orders#new',
  #     :via => :get, :as => :new_student_order
  # match '/students/:student_id/orders/:year/:month' => 'student_orders#edit',
  #     :via => :get, :as => :edit_student_order
  resources :students do
    resources :orders, :controller => 'student_orders'
  end

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
  root :to => "home#index"
  match '' => 'home#index', :as => :dashboard

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
