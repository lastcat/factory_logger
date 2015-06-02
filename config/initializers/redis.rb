require "redis"
REDIS = Redis.new(host: FactoryLogger.config.redis_host || "localhost", port: FactoryLogger.config.redis_port || 6379)
