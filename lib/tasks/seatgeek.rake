task seatgeek: :environment do
  {
    'Manchester' => 'manchester.json',
    'New York' => 'ny.json',
    'Los Angeles' =>'la.json'
  }.each do |city, filename|
    path =  Rails.root.join('lib', 'tasks', filename)
    f = File.open(path)
    search_results = JSON.parse(f.read)
    process_city(search_results, city)
  end
end

def process_city(search_results, city)
  search_results['events'].each do |event|
    category = category_for(event)
    next unless category

    puts event['title']
    event = Event.create!(
      name: event['title'].truncate(30), starts_at: event['datetime_utc'],
      seatgeek_id: event['id'], category: category, admin: random_user,
      city: event['city'] || city, user_limit: nil)

    random_users(3).each do |user|
      event.memberships.create(user: user)
    end
  end
end

def category_for(event)
  taxonomy = event_taxonomy(event)
  return unless taxonomy
  if taxonomy['name'] == 'concert'
    Category.find_by!(name: 'Concert')
  elsif taxonomy['name'] == 'sports'
    Category.find_by!(name: 'Active')
  end
end

def event_taxonomy(event)
  event['taxonomies'].find { |t| t['name'] == 'concert' || t['name'] == 'sports' }
end

def random_user
  User.order('RANDOM()').first
end

def random_users(count)
  User.order('RANDOM()').limit(count)
end
