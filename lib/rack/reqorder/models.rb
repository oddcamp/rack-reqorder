module Rack::Reqorder::Models
  if Mongoid::VERSION.to_f >= 6
    REQUIRED = {required: true}
    NOT_REQUIRED = { required: false}
  else
    REQUIRED = {}
    NOT_REQUIRED = {}
  end
end

require 'rack/reqorder/models/statistic'
require 'rack/reqorder/models/http_request'
require 'rack/reqorder/models/route_path'
require 'rack/reqorder/models/http_response'
require 'rack/reqorder/models/app_fault'
require 'rack/reqorder/models/app_exception'
require 'rack/reqorder/models/recording'
require 'rack/reqorder/models/configuration'
