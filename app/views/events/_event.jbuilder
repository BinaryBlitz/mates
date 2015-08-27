json.extract! event,
              :id, :name, :starts_at, :city, :latitude, :longitude, :info,
              :visibility, :created_at, :address, :user_limit, :photo_url,
              :min_age, :max_age, :gender, :category_id

json.user_count event.users.count

json.admin do
  json.extract! event.admin, :id, :first_name, :last_name
end
