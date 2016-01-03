json.array! @invites do |invite|
  json.extract! invite, :id

  json.user do
    json.partial! 'users/user', user: invite.user
  end
end
