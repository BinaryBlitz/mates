require 'mqtt'
require 'json'
require 'net/http'

uri = URI('http://partyapp.binaryblitz.ru/api/messages')
headers = { "Content-Type" => "application/json", "Accept" => "application/json" }
http = Net::HTTP.new(uri.host, uri.port)

MQTT::Client.connect('mqtt://localhost') do |client|
  client.subscribe('users/#')

  client.get do |topic, message|
    user_id = topic.split('/').pop
    creator_id, content = message.split(':')
    content = content.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')

    params = { message: { user_id: user_id, creator_id: creator_id, content: content } }.to_json
    response = http.post(uri.path, params, headers)

    puts response
  end
end
