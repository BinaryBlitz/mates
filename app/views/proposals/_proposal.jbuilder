json.extract! proposal, :id, :creator_id

json.creator do
  json.partial! 'users/user', user: proposal.creator
end

json.user do
  json.partial! 'users/user', user: proposal.user
end
