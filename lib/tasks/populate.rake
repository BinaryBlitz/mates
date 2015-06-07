namespace :db do
  task populate: :environment do
    # Users
    20.times do
      User.create!(
        first_name: FFaker::Name.first_name,
        last_name: FFaker::Name.last_name,
        nickname: FFaker::Internet.user_name,
        birthday: FFaker::Time.date,
        gender: FFaker::Boolean.random,
        password: FFaker::Internet.password,
        city: FFaker::AddressUS.city
        # avatar_url: FFaker::Avatar.image,
      )
    end

    # Friends
    User.all.each do |user|
      users = User.all.sample(8)

      # Friend requests
      users.pop(4).each do |friend|
        user.pending_friends << friend unless user.friends.include?(friend) || user == friend || friend.pending_friends.include?(user)
      end

      # Friendships
      users.pop(4).each do |friend|
        unless user.friends.include?(friend) || user == friend || friend.pending_friends.include?(user)
          user.friends << friend
        end
      end
    end

    # Events
    80.times do
      time = random_start_date
      Event.create!(
        name: FFaker::Movie.title[0...30],
        starts_at: time,
        ends_at: time + 2.hours,
        city: FFaker::AddressUS.city,
        latitude: FFaker::Geolocation.lat,
        longitude: FFaker::Geolocation.lng,
        info: FFaker::HipsterIpsum.sentence,
        address: FFaker::AddressUS.street_address,
        event_type: EventType.all.sample,
        user_limit: rand(100) + 1,
        visibility: ['public', 'private', 'friends'].sample,
        admin: User.all.sample
        # photo: FFaker::Avatar.image,
      )
    end

    # Event users
    Event.all.each do |event|
      limit = event.user_limit / 3
      users = User.all.sample(limit)
      event.users << users.pop(limit / 3)
      event.invited_users << users.pop(limit / 3)
      users.pop(limit / 3).each { |user| event.propose(user, event.admin) }
    end
  end

  def random_start_date
    [true, false].sample ? rand(10.years).seconds.ago : rand(10.years).seconds.from_now
  end
end
