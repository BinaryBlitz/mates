Rails.application.routes.draw do
  namespace :web do
    resources :events, only: :show, param: :sharing_token
  end

  scope '/api', defaults: { format: :json } do
    # Users
    resources :users, except: [:new, :edit] do
      collection do
        post 'authenticate'
        post 'authenticate_vk'
        post 'authenticate_fb'
        post 'authenticate_phone_number'
        post 'authenticate_layer'
        get 'search'
      end
      member do
        get 'events'
        get 'friends'
        get 'available_events'
        post 'notify'
        post 'favorite'
        delete 'unfavorite'
      end
    end
    resources :friend_requests, except: [:show, :new, :edit]
    resources :friends, only: [:index, :destroy]
    resources :favorites, only: [:index]
    resources :device_tokens, only: [:create, :destroy], param: :token
    resources :messages, only: [:index, :create] do
      delete :clean_up, on: :collection
    end

    # Events
    resources :events, except: [:new, :edit] do
      collection do
        get 'owned'
        get 'feed'
        get 'search'
        get 'by_token'
      end
      member do
        get 'proposals'
        get 'submissions'
        get 'available_friends'
        post 'join'
        delete 'remove'
        delete 'leave'
      end
      resources :comments, except: [:new, :edit], shallow: true
    end
    resources :categories, only: [:index]
    resources :invites, except: [:new, :edit]
    resources :proposals, except: [:index, :new, :edit]
    resources :memberships, except: [:new, :edit]
    resources :submissions, except: [:new, :edit]
    resources :searches, only: [:create, :show]
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
