require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/streaming'
require 'rack/cache'
require 'json'
require 'ostruct'

require 'pry'

require 'better_errors' if ENV['RACK_ENV'] == 'development'

require_relative './config/initialisers/init'
require_relative './lib/max_monitor/data'

class WebApp < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
    use BetterErrors::Middleware
  end

  configure do
    mime_type :event_stream, 'text/event-stream'
  end

  helpers Sinatra::Streaming

  get '/' do
    erb :index
  end

  get '/data-stream', provides: :event_stream do
    stream do |out|
      DataMonitor::Data.new.read do |node_name, channel, payload|
        begin
          out << message(node_name, channel, payload)
          break if out.closed?
        rescue IOError => e
          puts "Exception: #{e.inspect}"
          out.close
          break
        end
      end
    end
  end

  private

    def message node_name, channel, payload
      event = 'data'

      data = {
        node_name:  node_name,
        channel:    channel,
        payload:    payload,
        updated:    Time.now
      }

      "event: %s\ndata: %s\n\n" % [ event, data.to_json ]
    end
end
