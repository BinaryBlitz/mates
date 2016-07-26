json.extract! submission, :id

json.user do
  json.partial! 'api/users/user', user: submission.user
end

json.event do
  json.partial! 'api/events/event_preview', event: submission.event
end
