Rails.application.routes.draw do
  scope '/api', defaults: { format: :json } do
    # Users
    resources :users, except: [:new, :edit] do
      collection do
        post 'authenticate'
        post 'authenticate_vk'
        post 'authenticate_fb'
      end
      member do
        get 'events'
        get 'friends'
        post 'favorite'
        delete 'unfavorite'
      end
    end
    resources :friend_requests, except: [:show, :new, :edit]
    resources :friends, only: [:index, :destroy]
    resources :favorites, only: [:index]

    # Events
    resources :events, except: [:new, :edit] do
      collection do
        get :owned
        get :feed
      end
      member do
        get :proposals
        delete :remove
        delete :leave
      end
      resources :comments, except: [:new, :edit]
    end
    resources :event_types, only: [:index]
    resources :invites, except: [:new, :edit]
    resources :proposals, except: [:index, :new, :edit]
    resources :memberships, except: [:new, :edit]
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
