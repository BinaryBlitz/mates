Rails.application.routes.draw do
  namespace :web do
    resources :events, only: :show, param: :sharing_token
  end

  scope '/api' do
    # Auth & users
    resources :verification_tokens, only: [:create, :update], param: :token
    resources :device_tokens, only: [:create, :destroy], param: :token
    resources :users, except: [:index, :new, :edit] do
      resources :memberships, only: [:index], controller: 'user_memberships'
      get 'search', on: :collection
      get 'friends', on: :member
    end

    # Friends
    resources :friend_requests, except: [:show, :new, :edit] do
      patch 'decline', on: :member
    end
    resources :friends, only: [:index, :destroy]

    # Feeds
    resources :offers, only: [:index]
    resource :activity, only: [:show]
    resource :feed, only: [] do
      get 'friends', 'recommended'
    end

    # Events
    resources :memberships, only: [:destroy]
    resources :searches, only: [:create, :show]
    resources :categories, only: [:index]
    resources :events, except: [:index, :new, :edit] do
      get 'owned', 'by_token', on: :collection
      get 'available_friends', on: :member

      resources :comments, except: [:show, :new, :edit], shallow: true
      resources :memberships, only: [:index, :create], controller: 'event_memberships'
      resources :invites, except: [:show, :new, :edit], shallow: true do
        patch 'decline', on: :member
      end
      resources :submissions, except: [:show, :new, :edit], shallow: true do
        patch 'decline', on: :member
      end
    end

    # Stuff
    resources :reports, only: [:create]
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
