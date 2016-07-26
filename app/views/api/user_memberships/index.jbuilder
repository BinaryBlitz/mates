json.array!(@memberships) do |membership|
  json.extract! membership, :id, :user_id, :created_at

  json.event do
    json.partial! 'api/events/event_detail', event: membership.event
  end
end
