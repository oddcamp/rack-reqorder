require 'rack/reqorder/version'
require 'active_support/inflector'
require 'mongoid'
require 'rack/reqorder/models/http_request'
require 'rack/reqorder/models/http_response'

Mongoid.load!("#{File.expand_path(File.dirname(__FILE__))}/mongoid.yml", :development)

module Rack
  module Reqorder
    class Test
      include Rack::Reqorder::Models

      def initialize(app)
        @app = app
      end

      def call(environment)
        #api_session = ApiSession.create(created_at: Time.now)
        request = Rack::Request.new(environment)
        #api_session.request

        HttpRequest.create(
          path: request.path,
          full_path: request.fullpath,
          headers: extract_all_headers(request),
          parameters: request.params,
        )

        status, headers, body = @app.call(request.env)

        response = Rack::Response.new(body, status, headers)

        HttpResponse.create(
          headers: response.headers,
          #body: response.body.first,
          status: response.status.to_i
        )

        binding.pry

        response.finish

      end

      def extract_all_headers(request)
        Hash[
          request.env.select{|k,v|
            k.start_with? 'HTTP_'
          }.map{|k,v|
            [k.gsub('HTTP_','').upcase, v]
          }
        ]
      end
    end
  end
end
