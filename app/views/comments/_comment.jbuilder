json.extract! comment, :id, :content, :created_at
json.user do
  json.partial! 'users/user', user: comment.user
end
