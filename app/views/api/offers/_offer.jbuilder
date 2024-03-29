json.extract! offer, :id, :user_id, :accepted, :created_at, :updated_at

json.event do
  json.cache! ['event-preview', offer.event], expires_in: 2.minutes do
    json.partial! 'api/events/event_preview', event: offer.event
  end
end

json.user do
  json.cache! ['user-preview', offer.user], expires_in: 2.minutes do
    json.partial! 'api/users/user', user: offer.user
  end
end

if offer.respond_to?(:creator)
  json.creator do
    json.cache! ['user-preview', offer.creator], expires_in: 2.minutes do
      json.partial! 'api/users/user', user: offer.creator
    end
  end
end
