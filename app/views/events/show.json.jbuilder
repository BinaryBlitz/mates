json.extract! @event, :id, :name, :target, :start_at, :end_at, :city, :address, :latitude,
:longitude, :info, :visible, :photo_url
json.users @event.users do |user|
  json.partial! 'users/user', user: user
end
if current_user == @event.admin
  json.proposals @event.proposals do |proposal|
    json.partial! 'proposals/proposal', proposal: proposal
  end
end
