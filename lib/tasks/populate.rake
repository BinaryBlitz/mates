namespace :db do
  task populate: :environment do
    populate_users
    populate_friends
    populate_events
    populate_event_users
    populate_comments
  end

  def populate_users
    puts 'Populating users'

    20.times do
      User.create!(
        first_name: FFaker::Name.first_name,
        last_name: FFaker::Name.last_name,
        birthday: FFaker::Time.date,
        gender: random_gender,
        password: FFaker::Internet.password,
        city: FFaker::AddressUS.city
        # remote_avatar_url: FFaker::Avatar.image
      )
    end
  end

  def populate_events
    puts 'Populating events'

    40.times do |i|
      Event.create!(
        name: FFaker::Movie.title[0...30],
        starts_at: random_start_date,
        city: FFaker::AddressUS.city,
        latitude: FFaker::Geolocation.lat,
        longitude: FFaker::Geolocation.lng,
        info: FFaker::HipsterIpsum.sentence,
        address: FFaker::AddressUS.street_address,
        category: random_category,
        user_limit: rand(100) + 2,
        visibility: random_visibility,
        min_age: rand(20) + 1,
        max_age: rand(20) + 20,
        gender: [nil, 'm', 'f'].sample,
        creator: i == 0 ? User.first : random_user
      )
    end
  end

  def populate_friends
    puts 'Populating friends'

    User.all.each do |user|
      users = random_users(10).to_a

      # Friend requests
      users.pop(5).each do |friend|
        user.pending_friends << friend unless user.friends.include?(friend) || user == friend || friend.pending_friends.include?(user)
      end

      # Friendships
      users.pop(5).each do |friend|
        unless user.friends.include?(friend) || user == friend || friend.pending_friends.include?(user)
          user.friends << friend
        end
      end
    end
  end

  def populate_event_users
    puts 'Populating event users'

    # Event users
    Event.all.each do |event|
      limit = event.user_limit / 3
      users = random_users(limit).to_a
      users.pop(limit / 3).each { |u| event.users << u unless event.users.include?(u) }
      users.pop(limit / 3).each { |u| event.invited_users << u unless event.invited_users.include?(u) }
      users.pop(limit / 3).each { |u| event.propose(u, event.creator) }
    end
  end

  def populate_comments
    puts 'Populating comments'

    Event.all.each do |event|
      author = event.users.order('RANDOM()').first
      event.comments.create(content: FFaker::Lorem.sentence, user: author)
    end
  end

  def random_start_date
    [true, false].sample ? rand(10.years).seconds.ago : rand(10.years).seconds.from_now
  end

  def random_user
    User.order('RANDOM()').first
  end

  def random_users(count)
    User.order('RANDOM()').limit(count)
  end

  def random_category
    Category.order('RANDOM()').first
  end

  def random_gender
    ['f', 'm'].sample
  end

  def random_visibility
    %w(public private friends).sample
  end
end
