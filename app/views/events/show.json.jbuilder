json.extract! @event, :id, :name, :starts_at, :ends_at, :city, :latitude, :longitude, :info,
  :visibility, :created_at, :address, :photo_url

json.event_type do
  json.partial! 'event_types/event_type', event_type: @event.event_type
end

json.admin do
  json.partial! 'users/user', user: @event.admin
end

json.users @event.users do |user|
  json.partial! 'users/user', user: user
end

if policy(@event).update?
  json.proposed_users @event.proposed_users do |proposed_user|
    json.partial! 'users/user', user: proposed_user
  end
  json.invited_users @event.invited_users do |invited_user|
    json.partial! 'users/user', user: invited_user
  end
end

json.comments @event.comments do |comment|
  json.partial! 'comments/comment', comment: comment
end
