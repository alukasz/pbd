# PBD

Database for managing conferences.

## Requirements

  * [Ruby](https://gorails.com/setup/ubuntu/16.04) (just ruby, not rails)
  * Bundler (gem install bundler)
  * mysql

## Commands

  * Create database: `bundle exec rake db:create`
  * Run migrations: `bundle exec rake db:migrate`
  * Reset database: `bundle exec rake db:drop db:create db:migrate`
  * Run application in [IRB](https://en.wikipedia.org/wiki/Interactive_Ruby_Shell): `bundle exec bin/console`
