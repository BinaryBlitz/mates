json.extract! event,
              :id, :name, :starts_at, :city, :latitude, :longitude, :info,
              :visibility, :created_at, :address, :user_limit, :photo_url,
              :min_age, :max_age, :gender, :category_id, :extra_category_id

json.user_count event.users.count
json.friend_count event.friend_count(current_user)

json.invite current_user.invites.find_by(event: event)
json.submission current_user.submissions.find_by(event: event)

json.creator do
  json.partial! 'users/user', user: event.creator
end
