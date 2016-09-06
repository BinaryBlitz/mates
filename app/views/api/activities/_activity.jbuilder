json.extract! activity, :id, :user_id, :created_at, :updated_at
json.accepted activity.accepted unless activity.is_a?(Membership)

json.event do
  json.cache! ['event-preview', activity.event], expires_in: 2.minutes do
    json.partial! 'api/events/event_preview', event: activity.event
  end
end

json.user do
  json.cache! ['user-preview', activity.user], expires_in: 2.minutes do
    json.partial! 'api/users/user', user: activity.user
  end
end
