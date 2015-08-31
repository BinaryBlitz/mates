json.partial! 'event', event: @event

json.sharing_url web_event_url({sharing_token: @event.sharing_token})

json.users @event.users do |user|
  json.partial! 'users/user', user: user
end

json.owned current_user.owned_events.include?(@event)
json.visited current_user.events.include?(@event)
json.invite current_user.invites.find_by(event: @event)
json.submission current_user.submissions.find_by(event: @event)

if policy(@event).update?
  json.proposals @event.proposals do |proposal|
    json.partial! 'proposals/proposal', proposal: proposal
  end
  json.invites @event.invites do |invite|
    json.partial! 'invites/invite', invite: invite
  end
  json.submissions @event.submissions do |submission|
    json.partial! 'submissions/submission', submission: submission
  end
end

json.comments @event.comments do |comment|
  json.partial! 'comments/comment', comment: comment
end
