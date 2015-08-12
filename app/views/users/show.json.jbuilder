json.partial! 'user', user: @user

json.events @user.events, partial: 'events/event', as: :event
json.friends @user.friends, partial: 'users/user', as: :user

json.photos @user.photos do |photo|
  json.extract! photo, :id, :image_url
end
