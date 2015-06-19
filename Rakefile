require "bundler/gem_tasks"
require 'rack/reqorder/api/api'

namespace :grape do
  desc 'Print compiled grape routes'
  task :routes do
    Rack::Reqorder::Api.routes.each do |route|
      puts route
    end
  end
end

