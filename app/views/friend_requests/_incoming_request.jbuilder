json.extract! friend_request, :id, :created_at, :updated_at
json.user do
  json.partial! 'users/user', user: friend_request.user
end
