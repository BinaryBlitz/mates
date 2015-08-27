json.partial! 'user', user: @user

if current_user
  json.is_favorite current_user.favorite?(@user)
  json.is_pending_friend current_user.pending_friend?(@user)
  json.is_friend current_user.friend?(@user)
end

if @user == current_user
  json.preferences @user.preferences
end

json.events @user.events, partial: 'events/event', as: :event
json.friends @user.friends, partial: 'users/user', as: :user

json.photos @user.photos do |photo|
  json.extract! photo, :id, :image_url
end
