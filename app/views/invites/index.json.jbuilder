json.array!(@invites) do |invite|
  json.partial! 'invites/invite', invite: invite
end
