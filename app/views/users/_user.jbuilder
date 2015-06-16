json.extract! user,
              :id, :first_name, :last_name, :nickname,
              :birthday, :gender, :city, :avatar_url,
              :vk_url, :facebook_url, :twitter_url, :instagram_url
json.phone_number user.phone_number.try(:phony_formatted, format: :international)

if current_user
  json.is_favorite current_user.favorite?(user)
  json.is_pending_friend current_user.pending_friend?(user)
  json.is_friend current_user.friend?(user)
end
