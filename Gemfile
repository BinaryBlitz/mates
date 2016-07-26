source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '~> 5.0.0'
gem 'pg'
gem 'jbuilder'
gem 'puma'

# Push notifications
gem 'rpush'
# Geolocation
gem 'geocoder'

# Utilities
gem 'phony_rails'
gem 'validate_url'
gem 'httparty'

# Attachments
gem 'carrierwave'
gem 'carrierwave-base64'
gem 'mini_magick'

# Auth
gem 'pundit'
gem 'has_secure_token'

# Front-end
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'sprockets'

# Analytics
gem 'newrelic_rpm'

group :development do
  # Spring speeds up development by keeping your application running in the background.
  gem 'spring'
  gem 'spring-watcher-listen'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  # Model and test annotations
  gem 'annotate'
  # Pry console
  gem 'pry-rails'
  # Database seeds
  gem 'ffaker'
  # Optimization
  gem 'traceroute'
  gem 'bullet'
end

group :test do
  # Mocking
  gem 'mocha'
end

group :production do
  # Heroku gem
  gem 'rails_12factor'
  # AWS adapter for CarrierWave
  gem 'fog-aws'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end
