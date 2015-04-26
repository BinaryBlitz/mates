json.array!(@memberships) do |membership|
  json.extract! membership, :id
end
