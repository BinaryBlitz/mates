json.extract! submission, :id

json.user do
  json.partial! 'users/user', user: submission.user
end

json.event do
  json.partial! 'events/event_preview', event: submission.event
end
