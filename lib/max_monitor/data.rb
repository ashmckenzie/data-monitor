# encoding: UTF-8

module DataMonitor
  class Data

    def read
      DataMonitor::Redis.connection.subscribe('max-room:humidity') do |on|
        on.message do |key, payload|
          payload = payload.to_f
          _, node_name, channel = key.split(':')
          # puts "#{Time.now}: Received node_name:#{node_name}, channel:#{channel}, payload:#{payload}"
          yield node_name, channel, payload
        end
      end
    end
  end
end
