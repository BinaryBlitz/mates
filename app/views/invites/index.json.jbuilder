json.array!(@invites) do |invite|
  json.extract! invite, :id
  json.url invite_url(invite, format: :json)
end
