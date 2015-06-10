json.extract! event,
              :id, :name, :starts_at, :ends_at, :city, :latitude, :longitude, :info,
              :visibility, :created_at, :address, :user_limit, :photo_url

json.owned current_user.owned_events.include?(event)
json.visited current_user.events.include?(event)
json.invited current_user.invited_events.include?(event)

json.event_type do
  json.partial! 'event_types/event_type', event_type: event.event_type
end

json.admin do
  json.partial! 'users/user', user: event.admin
end
