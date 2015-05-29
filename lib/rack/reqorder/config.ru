require_relative '../reqorder'

Rack::Reqorder.configure do |config|
  config.mongoid_yml = "#{File.dirname(__FILE__)}/../../../mongoid.yml"
end

Rack::Reqorder.boot!

run Rack::Reqorder::Monitor::Api
