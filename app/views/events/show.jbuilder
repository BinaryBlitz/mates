json.extract! @event, :id, :name, :starts_at, :city, :photo_url, :category_id
json.sharing_url web_event_url({sharing_token: @event.sharing_token})

json.users @event.users do |user|
  json.partial! 'users/user', user: user
end

json.creator do
  json.partial! 'users/user', user: @event.creator
end

json.owned current_user.owned_events.include?(@event)
json.visited current_user.events.include?(@event)

if policy(@event).comment?
  json.comments @event.comments do |comment|
    json.partial! 'comments/comment', comment: comment
  end
end
