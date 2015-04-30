json.extract! event, :id, :name, :target, :starts_at, :ends_at, :city, :latitude, :longitude, :info,
  :visibility, :created_at, :address, :photo_url
json.admin do
  json.partial! 'users/user', user: event.admin
end
