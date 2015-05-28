require "active_support/configurable"
module FactoryLogger
  class Config
    include ActiveSupport::Configurable
    config_accessor :something
  end
  
  def self.configure(&block)
    yield config
  end

  def self.config
    @config ||= Config.new
  end
end
