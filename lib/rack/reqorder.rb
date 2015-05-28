require "ohm"
require 'ohm/contrib'
require "rack/reqorder/version"
require "rack/reqorder/models/http_request"
require "rack/reqorder/models/http_response"

module Rack
  module Reqorder
    class Test
      def initialize(app)
        @app = app
      end

      def call(environment)
        #api_session = ApiSession.create(created_at: Time.now)
        rack_req = Rack::Request.new(environment)
        #api_session.request
        binding.pry
        HttpRequest.create(
          path: rack_req.path,
          full_path: rack_req.fullpath,
          headers: extract_all_headers(rack_req),
          parameters: rack_req.params,
        )

        binding.pry
        puts environment
        status, headers, body = @app.call(rack_req.env)
        puts status
        puts headers

        response = Rack::Response.new(body, status, headers)

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
