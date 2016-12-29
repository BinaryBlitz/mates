Rails.application.routes.draw do
  namespace :web do
    resources :events, only: :show, param: :sharing_token
    get 'events/frontend/:id', to: 'events#frontend_show'
  end

  namespace :api do
    # Auth & users
    resources :verification_tokens, only: [:create, :update], param: :token
    resources :social_tokens, only: [:create]
    resources :device_tokens, only: [:create, :destroy], param: :token
    resources :users, except: [:index, :new, :edit] do
      resources :memberships, only: [:index], controller: 'user_memberships'
      get 'search', on: :collection
      get 'friends', on: :member
      post 'authenticate_layer', on: :collection
    end

    # Friends
    resources :friend_requests, except: [:show, :new, :edit] do
      patch 'decline', on: :member
      get 'number_of_incoming', on: :collection
    end
    resources :friends, only: [:index, :destroy]

    # Feeds
    resources :offers, only: [:index] do
      get 'number_of_incoming', on: :collection
    end
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
      post 'default_photo', on: :collection

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
end
