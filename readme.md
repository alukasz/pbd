# PBD

Database for managing conferences.

## Requirements

  * [Ruby](https://gorails.com/setup/ubuntu/16.04) >=2.2 (just ruby, not rails)
  * Bundler (gem install bundler)
  * mysql (`sudo apt-get install mysql-server-5.6`)
  * libmysqlclient-dev for 'mysql2' gem`sudo apt-get install libmysqlclient-dev`

## Installation

  * Clone or download repo
  * `bundle install`
  * update mysql username and password in `db/config.yml`
  * `bundle exec rake db:create db:migrate`

## Commands

  * Create database: `bundle exec rake db:create`
  * Run migrations: `bundle exec rake db:migrate`
  * Reset database: `bundle exec rake db:drop db:create db:migrate`
  * Run application in [IRB](https://en.wikipedia.org/wiki/Interactive_Ruby_Shell): `bundle exec bin/console`. This will load all models, connect to the database and start IRB session. All the power of [ActiveRecord](http://guides.rubyonrails.org/active_record_querying.html).
