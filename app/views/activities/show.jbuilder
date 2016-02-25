json.outgoing_friend_requests @activity.outgoing_friend_requests do |friend_request|
  json.cache! ['activity', friend_request], expires_in: 2.minutes do
    json.partial! 'friend_requests/outgoing_request', friend_request: friend_request
  end
end

json.submissions @activity.submissions do |activity|
  json.cache! ['activity', activity], expires_in: 2.minutes do
    json.partial! 'activity', activity: activity
  end
end

json.invites @activity.invites do |activity|
  json.cache! ['activity', activity], expires_in: 2.minutes do
    json.partial! 'activity', activity: activity
  end
end

json.memberships @activity.memberships do |activity|
  json.cache! ['activity', activity], expires_in: 2.minutes do
    json.partial! 'activity', activity: activity
  end
end
