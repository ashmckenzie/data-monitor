require 'singleton'
require 'hashie'
require 'yaml'

module DataMonitor

  class Config

    include Singleton

    def self.get; instance.get; end
    def self.read!(file); instance.read!(file); end

    def initialize
      read!
    end

    def get
      config
    end

    def read! file='./config/config.yml'
      @config = Hashie::Mash.new(YAML.load_file(file))
    end

    private

      attr_reader :config

  end
end
