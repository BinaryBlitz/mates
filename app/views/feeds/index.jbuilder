json.cache! ['feed', @events], expires_in: 5.minutes do
  json.array! @events do |event|
    json.cache! ['feed', event], expires_in: 5.minutes do
      json.extract! event, :id, :photo_url, :city, :starts_at

      json.creator do
        json.extract! event.creator, :id, :first_name, :last_name, :avatar_url
      end

      json.user_count event.users.count
    end
  end
end
