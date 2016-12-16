json.outgoing_invites @offers.outgoing_invites do |offer|
  json.cache! ['offer', offer], expires_in: 2.minutes do
    json.partial! 'offer', offer: offer
  end
end

json.incoming_invites @offers.incoming_invites do |offer|
  json.cache! ['offer', offer], expires_in: 2.minutes do
    json.partial! 'offer', offer: offer
  end
end

json.outgoing_submissions @offers.outgoing_submissions do |offer|
  json.cache! ['offer', offer], expires_in: 2.minutes do
    json.partial! 'offer', offer: offer
  end
end

json.incoming_submissions @offers.incoming_submissions do |offer|
  json.cache! ['offer', offer], expires_in: 2.minutes do
    json.partial! 'offer', offer: offer
  end
end

json.outgoing_invites_count @offers.outgoing_invites.count
json.incoming_invites_count @offers.incoming_invites.count
