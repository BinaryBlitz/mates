json.array! @proposals do |proposal|
  json.extract! proposal, :id
  json.creator do
    json.partial! 'users/user', user: proposal.creator
  end
  json.user do
    json.partial! 'users/user', user: proposal.user
  end
end
