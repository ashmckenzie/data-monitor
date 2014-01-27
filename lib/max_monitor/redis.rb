require 'redis'
require 'redis/namespace'

module DataMonitor

  class Redis

    include Singleton

    def self.connection; instance.connection; end

    def connection
      @connection ||= ::Redis::Namespace.new('rpi-moteino-collector', redis: ::Redis.new())
    end
  end
end
