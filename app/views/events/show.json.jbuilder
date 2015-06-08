json.partial! 'event', event: @event

json.users @event.users do |user|
  json.partial! 'users/user', user: user
end

if policy(@event).update?
  json.proposals @event.proposals do |proposal|
    json.partial! 'proposals/proposal', proposal: proposal
  end
  json.invites @event.invites do |invite|
    json.partial! 'invites/invite', invite: invite
  end
end

json.comments @event.comments do |comment|
  json.partial! 'comments/comment', comment: comment
end
