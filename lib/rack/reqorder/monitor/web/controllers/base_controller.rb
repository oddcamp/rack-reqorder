module Rack::Reqorder::Monitor::Web::Controllers
  M = Rack::Reqorder::Models
  P = Rack::Reqorder::Monitor::Web::Controllers

  class Base
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def resolve(hash = {})
      configuration = M::Configuration.first_or_create

      hash.merge({
        exception_monitoring: configuration.exception_monitoring,
        metrics_monitoring: configuration.metrics_monitoring,
        request_monitoring: configuration.request_monitoring
      })
    end
  end
end

require 'rack/reqorder/monitor/web/controllers/errors_controller'
require 'rack/reqorder/monitor/web/controllers/recordings_controller'
require 'rack/reqorder/monitor/web/controllers/requests_controller'
require 'rack/reqorder/monitor/web/controllers/metrics_controller'
