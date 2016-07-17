json.extract! @event,
              :id, :name, :starts_at, :photo_url, :category_id, :description,
              :city, :latitude, :longitude,
              :user_limit, :min_age, :max_age, :gender, :visibility

json.user_count @event.users.count
json.sharing_url web_event_url({sharing_token: @event.sharing_token})

json.creator do
  json.partial! 'users/user', user: @event.creator
end

json.invite do
  invite = @event.invites.unreviewed.find_by(user: current_user)
  json.extract! invite, :id, :event_id, :user_id, :accepted, :created_at if invite
end

json.submission do
  submission = @event.submissions.unreviewed.find_by(user: current_user)
  json.extract! submission, :id, :event_id, :user_id, :accepted, :created_at if submission
end

if policy(@event).comment?
  json.comments @event.comments do |comment|
    json.partial! 'comments/comment', comment: comment
  end
end
