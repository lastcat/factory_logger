require "active_support/configurable"
module FactoryLogger
  class Config
    include ActiveSupport::Configurable
    config_accessor :redis_host
    config_accessor :redis_port
    config_accessor :mode
  end

  def self.configure(&block)
    yield config
  end

  def self.config
    @config ||= Config.new
  end
end
