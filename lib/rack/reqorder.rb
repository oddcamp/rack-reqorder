require 'pry'
require 'rack/reqorder/version'
require 'active_support/inflector'
require 'mongoid'
require 'rack/cors'
#require 'kaminari/models/mongoid_extension'
require 'rack/reqorder/route_recognizers'

module Rack
  module Reqorder
    extend Rack::Reqorder::GrapeRecognizer
    extend Rack::Reqorder::SinatraRecognizer
    extend Rack::Reqorder::RailsRecognizer

    class << self
      attr_accessor :configuration
    end

    def self.clean_database!
      [
        :AppException, :AppFault, :HttpRequest, :HttpResponse, :Recording,
        :RoutePath, :Statistic
      ].each do |model|
        Object.const_get("#{self}::Models::#{model.to_s}").delete_all
      end

      return true
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
          self.environment = default_environment
        end

      end

      def default_environment
        if Module.const_defined?(:Rails)
          return Rails.env
        else
          return ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
        end
      end

      def metrics_monitoring
        config.metrics_monitoring
      end

      def exception_monitoring
        config.exception_monitoring
      end

      def request_monitoring
        config.request_monitoring
      end

      def config
        Models::Configuration.first_or_create
      end
    end
  end
end

require 'rack/reqorder/models'
require 'rack/reqorder/services/backtrace_cleaner'
require 'rack/reqorder/logger'

#require 'rack/reqorder/monitor/api'
require 'rack/reqorder/monitor/web'

load 'rack/reqorder/tasks/routes.rake'
