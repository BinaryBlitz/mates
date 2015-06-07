json.incoming @incoming do |request|
  json.partial! 'incoming_request', friend_request: request
end
json.outgoing @outgoing do |request|
  json.partial! 'outgoing_request', friend_request: request
end

