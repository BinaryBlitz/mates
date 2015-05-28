json.array! @events do |event|
  json.partial! 'events/event', event: event
  json.users event.preview_users do |user|
    json.partial! 'users/user', user: user
  end
end
