# FactoryLogger

This gem gives you Factory logging model.For more detail, About motivation, please see <blog url>.

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

First, modify your factroy_girl's code as follows,

```ruby
#@ lib/factory_girl/factory_runnner.rb

instrumentation_payload = { name: @name, strategy: runner_strategy, traits: @traits, overrides: @overrides, factory: factory}
```

next, you register notification subscriber.write,

```ruby
ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |_name, start, finish, _id, payload| # rubocop:disable ParameterLists
  execution_time_in_seconds = finish - start

  FactoryLog.create(name: payload[:name],
                    traits: payload[:traits].to_s,
                    assos: FactoryInspector.factory_inspect(payload[:factory])[:assos].map{ |asso| asso[:name].to_sym }.to_s,
                    time: execution_time_in_seconds)
end
```
at `config/initializers/notifications.rb`.

If you want to factory's execution infos, after `rails c -etest`,

```
$ FactoryLog.time_ranking
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
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean_with(:truncation)
  DatabaseCleaner[:active_record, model: ActiveRecord::Base.using(:master)]
end

config.after(:each) do
  DatabaseCleaner.strategy = :truncation, {:except => %w[factory_logs]}
  DatabaseCleaner.clean
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/factory_logger/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
