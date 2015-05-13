# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Users and friends
foo = User.create(
  first_name: 'Foo', last_name: 'Bar', nickname: 'foobar',
  gender: true, password: 'foobar', phone_number: '+74995555557')
foo.update(api_token: 'foo')
baz = User.create(
  first_name: 'Baz', last_name: 'Qux', nickname: 'bazqux',
  gender: false, password: 'bazqux', phone_number: '+74995555558')
baz.update(api_token: 'baz')

jon = User.create(
  first_name: 'Jon', last_name: 'Snow', birthday: 15.years.ago,
  nickname: 'bastard', gender: true, password: 'jonsnow', phone_number: '+74995555555')
jon.update(api_token: 'jon')
sam = User.create(
  first_name: 'Sam', last_name: 'Tarly', birthday: 19.years.ago,
  nickname: 'the-slayer', gender: true, password: 'samtarly', phone_number: '+74995555556')
ygritte = User.create(
  first_name: 'Ygritte', last_name: 'The Wildling', birthday: 16.years.ago,
  nickname: 'kissed-by-fire', gender: false, password: 'ygritte')
mance = User.create(
  first_name: 'Mance', last_name: 'Rayder', birthday: 34.years.ago,
  nickname: 'king-beyond-the-wall', gender: true, password: 'mancerayder')

jon.friends << sam
sam.friends << jon
jon.pending_friends << ygritte
mance.pending_friends << jon

party, active = EventType.create([{ name: 'Party' }, { name: 'Active' }])

battle = Event.create(
  name: 'Battle of Castle Black', event_type: active, city: 'The North', admin: jon,
  starts_at: Time.now, ends_at: Time.now + 1.day, info: 'To the Wall!', address: 'Castle Black')
battle.users << sam
battle.invited_users << ygritte
battle.proposals.create(user: mance, creator: ygritte)
battle.comments.create(content: 'The night is gathering.', user: sam)
battle.comments.create(content: 'You know nothing, Jon Snow.', user: ygritte)

choosing = Event.create(
  name: "Night's Watch Choosing", event_type: party, city: 'Castle Black', admin: sam,
  info: "Choosing of the new Lord Commander of the Night's Watch")
choosing.users << jon

frey = User.create(
  first_name: 'Walder', last_name: 'Frey', birthday: 90.years.ago,
  nickname: 'the-late-walder-frey', gender: true, password: 'walderfrey')
robb = User.create(
  first_name: 'Robb', last_name: 'Stark', birthday: 16.years.ago,
  nickname: 'king-in-the-north', gender: true, password: 'robbstark')
bolton = User.create(
  first_name: 'Roose', last_name: 'Bolton', birthday: 37.years.ago,
  nickname: 'roose', gender: true, password: 'roosebolton')
cat = User.create(
  first_name: 'Catelyn', last_name: 'Tully', birthday: 34.years.ago,
  nickname: 'cat', gender: false, password: 'catelyn'
)

wedding = Event.create(
  name: 'The Red Wedding', event_type: party, city: 'The Twins', admin: frey,
  starts_at: Time.now, ends_at: Time.now + 1.day, info: "Everyone's invited.", address: 'The Twins')
wedding.users << robb
wedding.invited_users << cat
wedding.proposals.create(user: bolton, creator: robb)
wedding.comments.create(content: 'The Lannisters send their regards.', user: bolton)
wedding.comments.create(content: '...', user: robb)
