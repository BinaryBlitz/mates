# Users and friends
foo = User.create!(
  first_name: 'Foo', last_name: 'Bar',
  gender: 'm', birthday: 30.years.ago, phone_number: '+74995555557')
foo.update!(api_token: 'foobar')
baz = User.create!(
  first_name: 'Baz', last_name: 'Qux',
  gender: 'f', birthday: 30.years.ago, phone_number: '+74995555558')
baz.update!(api_token: 'bazqux')

# Google Cloud Messaging
gcm = Rpush::Gcm::App.new
gcm.name = 'android_app'
gcm.auth_key = Rails.application.secrets.gcm_auth_key
gcm.connections = 1
gcm.save!

# Apple Push Notification Service
# apns = Rpush::Apns::App.new
# apns.name = 'ios_app'
# apns.certificate = File.read('/path/to/sandbox.pem')
# apns.environment = 'sandbox'
# apns.password = 'certificate password'
# apns.connections = 1
# apns.save!

# Categories
Category.create!([
  { name: 'Bar / Club' }, { name: 'Cafe' }, { name: 'Movie' }, { name: 'Theater' },
  { name: 'Show' }, { name: 'Concert' }, { name: 'Tabletop games' }, { name: 'Active' },
  { name: 'Walk' }, { name: 'Outing' }, { name: 'Party' }, { name: 'Other' }
])

Rake::Task['db:populate'].invoke
