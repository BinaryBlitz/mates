json.extract! friend_request, :id, :created_at, :updated_at
json.friend do
  json.partial! 'api/users/user', user: friend_request.friend
end
