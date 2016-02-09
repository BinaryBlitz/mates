json.extract! offer, :id, :user_id, :accepted, :created_at, :updated_at

json.event do
  json.cache! ['event-preview', offer.event], expires_in: 2.minutes do
    json.partial! 'events/event_preview', event: offer.event
  end
end

json.user do
  json.cache! ['user-preview', offer.user], expires_in: 2.minutes do
    json.partial! 'users/user', user: offer.user
  end
end
