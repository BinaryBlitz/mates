json.outgoing_friend_requests @activity.outgoing_friend_requests do |activity|
  json.cache! activity, expires_in: 5.minutes do
    json.partial! 'activity', activity: activity
  end
end

json.submissions @activity.submissions do |activity|
  json.cache! activity, expires_in: 5.minutes do
    json.partial! 'activity', activity: activity
  end
end

json.invites @activity.invites do |activity|
  json.cache! activity, expires_in: 5.minutes do
    json.partial! 'activity', activity: activity
  end
end

json.memberships @activity.memberships do |activity|
  json.cache! activity, expires_in: 5.minutes do
    json.partial! 'activity', activity: activity
  end
end
