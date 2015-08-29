json.array!(@messages) do |message|
  json.extract! message, :id, :content, :creator_id, :user_id

  json.creator do
    json.partial! 'users/user', user: creator
  end

  json.user do
    json.partial! 'users/user', user: user
  end
end
