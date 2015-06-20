require 'rack/reqorder/version'
require 'active_support/inflector'
require 'mongoid'
require 'kaminari'
require 'kaminari/models/mongoid_extension'

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

    def self.paths
      return @paths unless @paths.blank?
      @paths = {}
      Rails.application.routes.routes.routes.each do |route|
        @paths[route.defaults] = route.path.spec.left.to_s
      end

      return @paths
    end

    def self.recognise_path(path_uri, options = {})
      Rack::Reqorder.paths[Rails.application.routes.recognize_path(path_uri, options)
        .select{|key, value| [:action, :controller].include?(key)}
      ]
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

Kaminari.configure do |config|
  # config.default_per_page = 25
  # config.max_per_page = nil
  # config.window = 4
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
end

require 'rack/reqorder/models/http_request'
require 'rack/reqorder/models/route_path'
require 'rack/reqorder/models/http_response'
require 'rack/reqorder/models/app_fault'
require 'rack/reqorder/models/app_exception'
require 'rack/reqorder/services/backtrace_cleaner'
require 'rack/reqorder/logger'
require 'rack/reqorder/monitor'

load 'rack/reqorder/tasks/routes.rake'
