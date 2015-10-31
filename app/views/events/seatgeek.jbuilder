json.array! @events do |event|
  json.extract! event,
                :id, :name, :starts_at, :city, :latitude, :longitude,
                :info, :visibility, :created_at, :address, :user_limit, :photo_url
  json.user_count event.users.count

  json.users do |user|
    json.extract! user, :id, :first_name, :last_name, :avatar_thumb_url
  end
end
