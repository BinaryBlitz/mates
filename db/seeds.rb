# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Users and friends
Event.destroy_all
User.destroy_all
foo = User.create(
  first_name: 'Foo', last_name: 'Bar', nickname: 'foobar',
  gender: true, password: 'foobar', phone_number: '+74995555557')
foo.update(api_token: 'foo')
baz = User.create(
  first_name: 'Baz', last_name: 'Qux', nickname: 'bazqux',
  gender: false, password: 'bazqux', phone_number: '+74995555558')
baz.update(api_token: 'baz')

bazbazbaz = User.create(
  first_name: 'BazBaz', last_name: 'BAzQux', nickname: 'bazbazqux', gender: false, password: 'bazbazqux')
baz.update(api_token: 'bazbaz')

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
sam.friends << mance
mance.friends << sam
sam.friends << bazbazbaz
bazbazbaz.friends << sam
#sam has 3 friends jon, mance, bazbaz
#in past he participated with jon 2 mance 3 bazbazbaz 0
jon.pending_friends << ygritte
mance.pending_friends << jon

#id 1
battle = Event.create(
  name: 'Battle of Castle Black', target: 'The Wall', city: 'The North', admin: jon,
  starts_at: Time.now, ends_at: Time.now + 1.day, info: 'To the Wall!', address: 'Castle Black')
battle.users << sam
battle.invited_users << ygritte
battle.proposals.create(user: mance, creator: ygritte)
battle.comments.create(content: 'The night is gathering.', user: sam)
battle.comments.create(content: 'You know nothing, Jon Snow.', user: ygritte)

#id 2
choosing = Event.create(
  name: "Night's Watch Choosing", target: 'Choosing', city: 'Castle Black', admin: sam,
  info: "Choosing of the new Lord Commander of the Night's Watch")
choosing.users << jon
choosing.users << mance

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
#id 3
wedding = Event.create(
  name: 'The Red Wedding', target: 'Robb Stark', city: 'The Twins', admin: frey,
  starts_at: Time.now - 1.month, ends_at: Time.now - 15.day, info: "Everyone's invited.", address: 'The Twins')
wedding.users << robb
wedding.users << sam
wedding.invited_users << cat
wedding.proposals.create(user: bolton, creator: robb)
wedding.comments.create(content: 'The Lannisters send their regards.', user: bolton)
wedding.comments.create(content: '...', user: robb)

#my seeds
#id 4
choosing_past = Event.create(
  name: "Night's Watch Choosing 2", target: 'Choosing', city: 'Castle Black', admin: sam,
  starts_at: Time.now - 10.day, ends_at: Time.now - 3.day, info: "Choosing of the new Lord Commander of the Night's Watch")
choosing_past.users << mance

#id 5
past_wedding = Event.create(
  name: 'The Red Wedding -1', target: 'Robb Stark', city: 'The Twins', admin: frey,
  starts_at: Time.now - 20.day, ends_at: Time.now - 15.day, info: "Everyone's invited.", address: 'The Twins')
past_wedding.users << sam
past_wedding.users << mance
past_wedding.users << bazbazbaz

#id 6
wedding_next = Event.create(
  name: 'The Red Wedding 2', target: 'Robb Stark', city: 'The Twins2', admin: frey,
  starts_at: Time.now + 1.month, ends_at: Time.now + 2.month, info: "Everyone's invited.", address: 'The Twins')
wedding_next.users << cat
wedding_next.users << bolton

#id 7
wedding_three = Event.create(
  name: 'The Red Wedding 3', target: 'Robb Stark', city: 'The Twins2', admin: frey,
  starts_at: Time.now + 1.month, ends_at: Time.now + 2.month, info: "Everyone's invited.", address: 'The Twins')
wedding_three.users << robb
wedding_three.users << bolton

#id 8
battle_on_jon_side = Event.create(
  name: 'Battle of Castle Black 2 Jon!', target: 'The Wall', city: 'The North', admin: jon,
  starts_at: Time.now-28.days, ends_at: Time.now - 10.days, info: 'To the Wall!', address: 'Castle Black')
battle_on_jon_side.users << sam
battle_on_jon_side.users << ygritte
battle_on_jon_side.users << foo

#id 9
battle_another_side = Event.create(
  name: 'Battle of Castle Black 2 Mance!', target: 'The Wall', city: 'The North', admin: mance,
  starts_at: Time.now-28.days, ends_at: Time.now - 10.days, info: 'To the Wall!', address: 'Castle Black')
battle_another_side.users << sam
battle_another_side.users << ygritte
battle_another_side.users << foo


#id 9
mance_battle = Event.create(
  name: 'Battle of Castle Black 3 Mance', target: 'The Wall', city: 'The North', admin: mance,
  starts_at: Time.now+10.days, ends_at: Time.now + 15.days, info: 'To the Wall!', address: 'Castle Black')
mance_battle.users << baz
mance_battle.users << ygritte
mance_battle.users << foo

jon_battle = Event.create(
  name: 'Battle of Castle Black 3 Jon', target: 'The Wall', city: 'The North', admin: jon,
  starts_at: Time.now+10.days, ends_at: Time.now + 15.days, info: 'To the Wall!', address: 'Castle Black')

ygritte_battle = Event.create(
  name: 'Ygritte Battle !', target: 'The Foo', city: 'The FooFoo', admin: ygritte,
  starts_at: Time.now+28.days, ends_at: Time.now + 2.month, info: 'To the Wall!', address: 'Castle Black')
ygritte_battle.users << sam
ygritte_battle.users << foo