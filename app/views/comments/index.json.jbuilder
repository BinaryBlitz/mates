json.array!(@comments) do |comment|
  json.extract! comment, :id, :content
  json.partial! 'users/user', user: comment.user
end
