json.extract! user,
              :id, :first_name, :last_name, :email,
              :birthday, :gender, :city, :avatar_url,
              :vk_url, :facebook_url, :twitter_url, :instagram_url

json.avatar_thumb_url user.avatar.thumb.url

json.phone_number user.phone_number.try(:phony_formatted, format: :international)
