json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :nickname, :birthday, :gender, :api_token
  json.url user_url(user, format: :json)
end
