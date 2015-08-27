source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'

# Use PostgreSQL
gem 'pg'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'phony_rails'
gem 'ffaker'
gem 'rpush'
gem 'validate_url'
gem 'geocoder'

# Attachments
gem 'carrierwave'
gem 'carrierwave-base64'
gem 'mini_magick'

# Auth
gem 'vkontakte_api'
gem 'koala'
gem 'pundit'
gem 'has_secure_token'
gem 'bcrypt', '~> 3.1.7'
gem 'email_validator'

# Front end
gem 'sass-rails'
gem 'bootstrap-sass'

# Use Unicorn as the app server
gem 'unicorn'

gem 'mqtt'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'annotate', group: :development
# Use old version because of the manifest bug
gem 'sprockets', '2.12.3'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background.
  gem 'spring'
  # Mocking
  gem 'mocha'

  gem 'capistrano'
  gem "rvm-capistrano", require: false
end

group :production do
  gem 'rails_12factor'
end
