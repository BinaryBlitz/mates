json.array! @events do |event|
  json.extract! event, :id, :name, :starts_at, :city, :photo_url, :category_id
end
