json.partial! 'user', user: @user

json.extract! @user, :email, :birthday, :gender, :city, :avatar_url,
                     :vk_url, :facebook_url, :twitter_url, :instagram_url

json.phone_number @user.phone_number.try(:phony_formatted, format: :international)

if current_user
  json.is_favorite current_user.favorite?(@user)
  json.is_friend current_user.friend?(@user)
  json.friend_request current_user.friend_request_to_or_from(@user)
end

if @user == current_user
  json.preferences @user.preferences
end

json.events @user.events, partial: 'events/event', as: :event
json.friends @user.friends, partial: 'users/user', as: :user

json.photos @user.photos do |photo|
  json.extract! photo, :id, :image_url
end

json.interests @user.interests do |interest|
  json.extract! interest, :id, :category_id
end
