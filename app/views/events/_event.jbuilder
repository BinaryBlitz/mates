json.extract! event,
              :id, :name, :starts_at, :ends_at, :city, :latitude, :longitude, :info,
              :visibility, :created_at, :address, :user_limit, :photo_url,
              :min_age, :max_age, :gender

json.extract! event, :event_type_id

# json.event_type do
#   json.partial! 'event_types/event_type', event_type: event.event_type
# end

json.admin do
  json.extract! event.admin, :id, :first_name, :last_name
end
