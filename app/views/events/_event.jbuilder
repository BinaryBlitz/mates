json.extract! event,
              :id, :name, :starts_at, :city, :latitude, :longitude, :info,
              :visibility, :created_at, :address, :user_limit, :photo_url,
              :min_age, :max_age, :gender, :category_id, :extra_category_id

json.user_count event.users.count

json.admin do
  json.partial! 'users/user', user: event.admin
end

json.users event.preview_users do |user|
  json.partial! 'users/user', user: user
end
