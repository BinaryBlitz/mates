json.array!(@friends) do |friend|
  json.partial! 'api/users/user', user: friend
end
