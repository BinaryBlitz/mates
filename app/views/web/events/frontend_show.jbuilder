json.extract! @event,
              :id, :name, :starts_at, :photo_url, :category_id, :description,
              :city, :latitude, :longitude,
              :user_limit, :min_age, :max_age, :gender, :visibility

json.user_count @event.users.count

json.creator do
  json.partial! 'api/users/user', user: @event.creator
end

json.users @event.users do |user|
  json.partial! 'api/users/user', user: user
end
