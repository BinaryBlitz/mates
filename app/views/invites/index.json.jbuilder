json.array!(@invites) do |invite|
  json.extract! invite, :id
end
