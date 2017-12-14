ENV["RAILS_ENV"] ||= "test"

require "coveralls"
Coveralls.wear!

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rspec/rails"
require "rspec/autorun"
require "factory_bot_rails"
require "database_cleaner"

Rails.backtrace_cleaner.remove_silencers!
# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.include FactoryBot::Syntax::Methods

  ###################### DatabaseCleaner Setting ######################
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
    REDIS.flushdb
  end
end
