# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Users and friends
foo = User.create(
  first_name: 'Foo', last_name: 'Bar', nickname: 'foobar',
  gender: 'm', password: 'foobar', phone_number: '+74995555557')
foo.update(api_token: 'foo')
baz = User.create(
  first_name: 'Baz', last_name: 'Qux', nickname: 'bazqux',
  gender: 'f', password: 'bazqux', phone_number: '+74995555558')
baz.update(api_token: 'baz')

# Event types
EventType.create([
  { name: 'Bar / Club' }, { name: 'Cafe' }, { name: 'Cinema' }, { name: 'Theater' },
  { name: 'Show' }, { name: 'Concert' }, { name: 'Tabletop games' }, { name: 'Active' },
  { name: 'Walk' }, { name: 'Outing' }, { name: 'Party' }, { name: 'Other' }
])

Rake::Task['db:populate'].invoke
