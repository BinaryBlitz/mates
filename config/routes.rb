Rails.application.routes.draw do
  namespace :web do
    resources :events, only: :show, param: :sharing_token
  end

  scope '/api' do
    # Users
    resources :verification_tokens, only: [:create, :update], param: :token
    resources :users, except: [:index, :new, :edit] do
      resources :memberships, only: [:index], controller: 'user_memberships'
      collection do
        get 'search'
      end
      member do
        get 'friends'
        get 'available_events'
        post 'notify'
      end
    end
    resources :friend_requests, except: [:show, :new, :edit]
    resources :friends, only: [:index, :destroy]
    resources :device_tokens, only: [:create, :destroy], param: :token

    # Events
    resources :events, except: [:new, :edit] do
      collection do
        get 'owned'
        get 'feed'
        get 'by_token'
      end
      member do
        get 'available_friends'
      end
      resources :comments, except: [:show, :new, :edit], shallow: true
      resources :memberships, only: [:index, :create, :destroy], controller: 'event_memberships', shallow: true
      resources :proposals, except: [:show, :new, :edit], shallow: true
      resources :invites, except: [:show, :new, :edit], shallow: true
      resources :submissions, except: [:show, :new, :edit], shallow: true
    end
    resources :categories, only: [:index]
    resources :searches, only: [:create, :show]
    resource :feed, only: [] do
      get 'friends', 'recommended'
    end
  end

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

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
