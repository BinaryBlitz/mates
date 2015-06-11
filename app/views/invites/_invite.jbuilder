json.extract! invite, :id
json.event do
  json.partial! 'events/event', event: invite.event
end
json.user do
  json.partial! 'users/user', user: invite.user
end
