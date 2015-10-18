json.array!(@messages) do |message|
  json.extract! message, :id, :content, :created_at

  json.creator do
    json.partial! 'users/user', user: message.creator
  end

  json.user do
    json.partial! 'users/user', user: message.user
  end
end
