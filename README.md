# FactoryLogger

This gem gives you Factory logging model.For more detail, About motivation, please see http://hackerslab.aktsk.jp/technology/factorygirl_log/.

[![Code Climate](https://codeclimate.com/github/lastcat/factory_logger/badges/gpa.svg)](https://codeclimate.com/github/lastcat/factory_logger)
[![Build Status](https://travis-ci.org/lastcat/factory_logger.svg?branch=setting_coveralls)](https://travis-ci.org/lastcat/factory_logger)
[![CircleCI](https://circleci.com/gh/lastcat/factory_logger.svg?style=svg)](https://circleci.com/gh/lastcat/factory_logger)
[![Coverage Status](https://coveralls.io/repos/lastcat/factory_logger/badge.svg?branch=master)](https://coveralls.io/r/lastcat/factory_logger?branch=master)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'factory_logger'
```

And then execute:

```
$ bundle install
$ bundle exec rake factory_logger_engine:install:migrations
$ bundle exec rake db:migrate
```

## Usage

First, you register notification subscriber.write,

```ruby
ActiveSupport::Notifications.subscribe("factory_bot.run_factory") do |_name, start, finish, _id, payload|
  execution_time_in_seconds = finish - start
  traits =  payload[:traits].map{|t| t.to_s}
  factory = FactoryInspector.factory_inspect(payload[:factory]).merge(traits: traits)
  FactoryLog.logging(factory, execution_time_in_seconds)
end
```

(I use [factory_inspector](https://github.com/lastcat/factory_inspector) to get factory's infos.This gem isn't dependent it, You can use or not.)

at `config/initializers/notifications.rb`.

If you want to factory's execution infos, after `rails c -etest`,

```
$ FactoryLog.ranking
$ Factory.all
$ Factory.find(2).traits
```

There are several class methods, please read `app/models/factory_log.rb`.

##Note

If you use `DatabaseCleaner` od `DatabseRewinder` in your testing, plobably you need to setting for excepting to `FactoryLog` model. For example, you wrote like,

```ruby
config.before(:suite) do
  DatabaseCleaner.strategy = :transaction
  DatabaseCleaner.clean_with(:truncation)
  DatabaseCleaner[:active_record, model: ActiveRecord::Base.using(:master)]
end
```

change like this,

```ruby
config.before(:suite) do
  REDIS.flushdb #this is Redis client for this engine.
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
  DatabaseCleaner[:active_record, model: ActiveRecord::Base.using(:master)]
end

config.after(:each) do
  DatabaseCleaner.strategy = :truncation, {:except => %w[factory_logs factories assos traits asso_relations trait_relations] }
  DatabaseCleaner.clean
end
```

This gem use [redis](http://redis.io/). You can configure setting configuration Like this,

```.rb
FactoryLogger.configure do |config|
  config.redis_host = "http://regis_host_url"
  config.redis_port = 4649
end
```

Default setting is `localhost`, and `6379` port. Sorry, now supporting tcp conecttion only (waiting for your contribute!).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/factory_logger/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
