json.extract! friend_request, :id, :created_at
json.friend do
  json.partial! 'users/user', user: friend_request.friend
end