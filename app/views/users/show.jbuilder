json.partial! 'user', user: @user

json.extract! @user, :birthday, :gender, :city, :avatar_url, :website_url

json.phone_number @user.phone_number.try(:phony_formatted, format: :international)
json.events_count @user.events.count
json.friends_count @user.friends.count

if current_user
  json.is_friend current_user.friend?(@user)
  json.friend_request current_user.friend_request_to_or_from(@user)
end

if @user == current_user
  json.preferences @user.preferences
end

json.photos @user.photos do |photo|
  json.extract! photo, :id, :image_url
end

json.interests @user.interests do |interest|
  json.extract! interest, :id, :category_id
end
