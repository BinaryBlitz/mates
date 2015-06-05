json.partial! 'user', user: @user
json.events @user.events, partial: 'events/event', as: :event
json.friends @user.friends, partial: 'users/user', as: :user
