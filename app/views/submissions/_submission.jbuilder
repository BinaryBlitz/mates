json.extract! submission, :id, :event_id

json.user do
  json.partial! 'users/user', user: submission.user
end
