json.array! @events do |event|
  json.extract! event, :id, :photo_url, :city, :starts_at

  json.creator do
    json.extract! event.creator, :id, :first_name, :last_name, :avatar_url
  end

  json.user_count event.users.count
end
