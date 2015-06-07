json.extract! user,
              :id, :first_name, :last_name, :nickname,
              :birthday, :gender, :city, :avatar_url
json.phone_number user.phone_number.try(:phony_formatted, format: :international)
json.favorite current_user.favorite?(user) if current_user
