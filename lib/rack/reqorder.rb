require 'rack/reqorder/version'
require 'active_support/inflector'
require 'mongoid'

module Rack
  module Reqorder
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def self.boot!
      self.configuration.validate!

      Mongoid.load!(
        self.configuration.mongoid_yml,
        self.configuration.environment
      )
    end

    class Configuration
      attr_accessor :mongoid_yml, :environment

      def validate!
        if mongoid_yml.blank?
          raise 'You need to setup mongoid.yml before using this gem'
        end

        if environment.blank?
          puts 'rack-reqorder: No environment found, assuming development environment'
          self.environment = :development
        end
      end
    end
  end
end

require 'rack/reqorder/models/http_request'
require 'rack/reqorder/models/http_response'
require 'rack/reqorder/logger'
