json.extract! proposal, :id, :creator_id
json.creator proposal.creator, partial: 'users/user', as: :user
json.user proposal.user, partial: 'users/user', as: :user
