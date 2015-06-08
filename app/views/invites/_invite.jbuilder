json.extract! invite, :id, :user_id, :event_id
json.user do
  json.partial! 'users/user', user: invite.user
end
