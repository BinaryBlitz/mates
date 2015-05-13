json.array!(@event_types) do |event_type|
  json.extract! event_type, :id, :name
end
