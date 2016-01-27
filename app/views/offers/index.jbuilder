json.outgoing_invites @offers.outgoing_invites do |offer|
  json.cache! offer, expires_in: 5.minutes do
    json.partial! 'offer', offer: offer
  end
end

json.incoming_invites @offers.incoming_invites do |offer|
  json.cache! offer, expires_in: 5.minutes do
    json.partial! 'offer', offer: offer
  end
end
json.outgoing_submissions @offers.outgoing_submissions do |offer|
  json.cache! offer, expires_in: 5.minutes do
    json.partial! 'offer', offer: offer
  end
end
json.incoming_submissions @offers.incoming_submissions do |offer|
  json.cache! offer, expires_in: 5.minutes do
    json.partial! 'offer', offer: offer
  end
end
