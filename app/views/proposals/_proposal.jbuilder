json.extract! proposal, :id, :creator_id
json.user do
  json.patial! 'users/user', user: proposal.user
end
