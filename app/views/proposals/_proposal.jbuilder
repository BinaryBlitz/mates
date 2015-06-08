json.extract! proposal, :id, :creator_id
json.user do
  json.partial! 'users/user', user: proposal.user
end
