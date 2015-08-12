json.extract! comment, :id, :content, :created_at

json.user do
  json.partial! 'users/user', user: comment.user
end

if comment.respondent
  json.respondent do
    json.partial! 'users/user', user: comment.respondent
  end
else
  json.respondent nil
end

