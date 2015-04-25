json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :nickname, :birthday, :gender, :api_token, :avatar_url
  json.url user_url(user, format: :json)
end
