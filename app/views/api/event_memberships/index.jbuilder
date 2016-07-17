json.array!(@memberships) do |membership|
  json.extract! membership, :id, :event_id, :created_at

  json.user do
    json.partial! 'api/users/user', user: membership.user
  end
end
