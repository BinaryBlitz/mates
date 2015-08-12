## README

### Ruby version
2.2.2

### System dependencies
`brew install postgresql`

`brew install imagemagick`

### Configuration

### Database creation
`cp config/database_sample.yml config/database.yml`

### Database initialization
`rake db:setup`

### How to run the test suite
`rake`

### Services (job queues, cache servers, search engines, etc.)
`rpush start`

### Deployment instructions
`cap deploy`
