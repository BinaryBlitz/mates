json.outgoing_friend_requests @activity.outgoing_friend_requests, :id, :user_id, :friend_id, :accepted, :created_at, :updated_at
json.incoming_friend_requests @activity.incoming_friend_requests, :id, :user_id, :friend_id, :accepted, :created_at, :updated_at
json.submissions @activity.submissions, :id, :user_id, :event_id, :accepted, :created_at, :updated_at
json.invites @activity.invites, :id, :user_id, :event_id, :accepted, :created_at, :updated_at
json.memberships @activity.memberships, :id, :user_id, :event_id, :created_at, :updated_at
