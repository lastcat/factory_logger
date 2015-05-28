$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "factory_logger/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "factory_logger"
  s.version     = FactoryLogger::VERSION
  s.authors     = ["yoshitake.nakaji"]
  s.email       = ["kokodoko966@gmail.com"]
  s.homepage    = "https://github.com/lastcat/factory_logger.git"
  s.summary     = "This is rails engine for logging FactoryGirl's execuation."
  s.description = "See <blog entry url>."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "database_cleaner"
end
