json.extract! event,
              :id, :name, :starts_at, :ends_at, :city, :latitude, :longitude, :info,
              :visibility, :created_at, :address, :user_limit, :photo_url,
              :min_age, :max_age, :gender

json.owned current_user.owned_events.include?(event)
json.visited current_user.events.include?(event)
json.invited current_user.invited_events.include?(event)

json.event_type do
  json.partial! 'event_types/event_type', event_type: event.event_type
end

json.admin do
  json.partial! 'users/user', user: event.admin
end

if submission = event.submissions.find_by(user: current_user)
  json.submission do
    json.partial! 'submissions/submission', submission: submission
  end
end
