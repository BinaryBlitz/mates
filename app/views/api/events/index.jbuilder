json.array! @events do |event|
  json.extract! event, :id, :name, :photo_url, :city, :starts_at, :category_id

  json.creator do
    json.extract! event.creator, :id, :first_name, :last_name, :avatar_url
  end

  json.user_count event.users.count
  json.friend_count event.users.where(id: current_user.friend_ids).count
end
