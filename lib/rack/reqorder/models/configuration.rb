module Rack::Reqorder::Models
  class Configuration
    include ::Mongoid::Document
    include ::Mongoid::Timestamps

    field :exception_monitoring, type: Boolean, default: true
    field :request_monitoring, type: Boolean, default: true
    field :metrics_monitoring, type: Boolean, default: true
  end
end
